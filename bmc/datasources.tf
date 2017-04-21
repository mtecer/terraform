# Gets a list of Availability Domains
data "baremetal_identity_availability_domains" "ADs" {
	compartment_id = "${var.tenancy_ocid}"
}

# Gets the OCID of the OS image to use
data "baremetal_core_images" "ImageOCID" {
	compartment_id = "${var.compartment_ocid}"
	operating_system = "${var.InstanceOS}"
	operating_system_version = "${var.InstanceOSVersion}"
}

# CORE0

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "ilo-poc-core0-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.ilo-poc-core0.id}" 
} 

# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "ilo-poc-core0-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.ilo-poc-core0-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# CORE1

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "ilo-poc-core1-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.ilo-poc-core1.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "ilo-poc-core1-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.ilo-poc-core1-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# DATA0

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "ilo-poc-data0-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.ilo-poc-data0.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "ilo-poc-data0-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.ilo-poc-data0-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# DATA1

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "ilo-poc-data1-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.ilo-poc-data1.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "ilo-poc-data1-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.ilo-poc-data1-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# HAPROXY

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "ilo-poc-haproxy-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.ilo-poc-haproxy.id}" 
} 
# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "ilo-poc-haproxy-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.ilo-poc-haproxy-Vnics.vnic_attachments[0],"vnic_id")}" 
}

# Gets a list of vNIC attachments on the instance
data "baremetal_core_vnic_attachments" "ilo-poc-pxb-Vnics" { 
	compartment_id = "${var.compartment_ocid}" 
	availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}" 
	instance_id = "${baremetal_core_instance.ilo-poc-pxb.id}" 
} 

# Gets the OCID of the first (default) vNIC
data "baremetal_core_vnic" "ilo-poc-pxb-Vnic" { 
	vnic_id = "${lookup(data.baremetal_core_vnic_attachments.ilo-poc-pxb-Vnics.vnic_attachments[0],"vnic_id")}" 
}

data "template_file" "etc_hosts" {
  template = "${file("${path.module}/templates/etc_hosts.tpl")}"
  vars {
      ilo-poc-core0   = "${data.baremetal_core_vnic.ilo-poc-core0-Vnic.private_ip_address}"
      ilo-poc-core1   = "${data.baremetal_core_vnic.ilo-poc-core1-Vnic.private_ip_address}"
      ilo-poc-data0   = "${data.baremetal_core_vnic.ilo-poc-data0-Vnic.private_ip_address}"
      ilo-poc-data1   = "${data.baremetal_core_vnic.ilo-poc-data1-Vnic.private_ip_address}"
      ilo-poc-haproxy = "${data.baremetal_core_vnic.ilo-poc-haproxy-Vnic.private_ip_address}"
      ilo-poc-pxb     = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.private_ip_address}"
  }
}

data "template_file" "etc_ansible_hosts" {
  template = "${file("${path.module}/templates/etc_ansible_hosts.tpl")}"
  vars {
      ilo-poc-core0   = "${data.baremetal_core_vnic.ilo-poc-core0-Vnic.private_ip_address}"
      ilo-poc-core1   = "${data.baremetal_core_vnic.ilo-poc-core1-Vnic.private_ip_address}"
      ilo-poc-data0   = "${data.baremetal_core_vnic.ilo-poc-data0-Vnic.private_ip_address}"
      ilo-poc-data1   = "${data.baremetal_core_vnic.ilo-poc-data1-Vnic.private_ip_address}"
      ilo-poc-haproxy = "${data.baremetal_core_vnic.ilo-poc-haproxy-Vnic.private_ip_address}"
      ilo-poc-pxb     = "${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.private_ip_address}"
  }
}

data "template_file" "pxb_bootstrap_sh" {
  template = "${file("${path.module}/templates/pxb-bootstrap.sh.tpl")}"
  vars {
      ssh_private_key= "${var.ssh_private_key}"
  }
}

