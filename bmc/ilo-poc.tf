resource "baremetal_core_instance" "ilo-poc-core0" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "ilo-poc-core0"
  hostname_label = "core0"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "ilo-poc-core1" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "ilo-poc-core1"
  hostname_label = "core1"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "ilo-poc-data0" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "ilo-poc-data0"
  hostname_label = "data0"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "ilo-poc-data1" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "ilo-poc-data1"
  hostname_label = "data1"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "ilo-poc-haproxy" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "ilo-poc-haproxy"
  hostname_label = "haproxy"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
}

resource "baremetal_core_instance" "ilo-poc-pxb" {
  depends_on = [
    "baremetal_core_instance.ilo-poc-core0",
    "baremetal_core_instance.ilo-poc-core1",
    "baremetal_core_instance.ilo-poc-data0",
    "baremetal_core_instance.ilo-poc-data1",
    "baremetal_core_instance.ilo-poc-haproxy",
  ]
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "ilo-poc-pxb"
  hostname_label = "pxb"
  image = "${lookup(data.baremetal_core_images.ImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${var.SubnetOCID}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    # user_data = "${base64encode(file(var.BootStrapFile))}"
    user_data = "${base64encode(data.template_file.pxb_bootstrap_sh.rendered)}"
  }
}

resource "null_resource" "etc_hosts" {
  triggers {
   content = "${data.template_file.etc_hosts.rendered}"
  }
  provisioner "file" {
    content     = "${data.template_file.etc_hosts.rendered}"
    destination = "/etc/hosts"
    connection {
      type    = "ssh"
      agent    = false
      timeout = "5m"
      host    = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.public_ip_address}"
      user    = "root"
      private_key = "${var.ssh_private_key}"
    }
  }
}

resource "null_resource" "etc_ansible_hosts" {
  triggers {
   content = "${data.template_file.etc_ansible_hosts.rendered}"
  }
  provisioner "file" {
    content     = "${data.template_file.etc_ansible_hosts.rendered}"
    destination = "/etc/ansible/hosts"
    connection {
      type    = "ssh"
      agent    = false
      timeout = "5m"
      host    = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.public_ip_address}"
      user    = "root"
      private_key = "${var.ssh_private_key}"
    }
  }
}

resource "null_resource" "ansible" {
  triggers {
   content = "${base64sha256(file("${path.module}/files/ansible.tgz"))}"
  }
  provisioner "file" {
    source          = "files/ansible.tgz"
    destination     = "~/ansible.tgz"
    connection {
      type    = "ssh"
      agent    = false
      timeout = "5m"
      host    = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.public_ip_address}"
      user    = "opc"
      private_key = "${var.ssh_private_key}"
    }
  }
}

resource "null_resource" "remote-exec" {
  triggers {
   content = "${base64sha256(file("${path.module}/files/ansible.tgz"))}"
  }
  depends_on = [
    "baremetal_core_instance.ilo-poc-pxb",
    "null_resource.ansible",
    ]
  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      agent    = false
      timeout = "5m"
      host    = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.public_ip_address}"
      user    = "opc"
      private_key = "${var.ssh_private_key}"
    }
    inline = [
      "tar xzvf ansible.tgz",
      "rm -vf ansible.tgz",
    ]
  }
}

resource "null_resource" "venrepo" {
  triggers {
   content = "${base64sha256(file("${path.module}/files/onpremgCBURz8Y4zkGk1u7N9ialjPGlZ.tgz"))}"
  }
  provisioner "file" {
    source          = "files/onpremgCBURz8Y4zkGk1u7N9ialjPGlZ.tgz"
    destination     = "~/onpremgCBURz8Y4zkGk1u7N9ialjPGlZ.tgz"
    connection {
      type    = "ssh"
      agent    = false
      timeout = "5m"
      host    = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.public_ip_address}"
      user    = "opc"
      private_key = "${var.ssh_private_key}"
    }
  }
}

resource "null_resource" "remote-exec" {
  triggers {
   content = "${base64sha256(file("${path.module}/files/onpremgCBURz8Y4zkGk1u7N9ialjPGlZ.tgz"))}"
  }
  depends_on = [
    "baremetal_core_instance.ilo-poc-pxb",
    "null_resource.venrepo",
    ]
  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      agent    = false
      timeout = "5m"
      host    = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.public_ip_address}"
      user    = "opc"
      private_key = "${var.ssh_private_key}"
    }
    inline = [
      "sudo mkdir -p /var/www/html",
      "sudo tar xzvf onpremgCBURz8Y4zkGk1u7N9ialjPGlZ.tgz --directory /var/www/html",
      "sudo chown -R opc.opc /var/www/html/onpremgCBURz8Y4zkGk1u7N9ialjPGlZ",
      "rm -vf onpremgCBURz8Y4zkGk1u7N9ialjPGlZ.tgz",
    ]
  }
}

