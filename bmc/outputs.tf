# Output the private and public IPs of the instance

#output "ilo-poc-core0-PrivateIP" {
#  value = ["${data.baremetal_core_vnic.ilo-poc-core0-Vnic.private_ip_address}"]
#}

output "ilo-poc-core0-PublicIP" {
  value = ["${data.baremetal_core_vnic.ilo-poc-core0-Vnic.public_ip_address}"]
}

#output "ilo-poc-core1-PrivateIP" {
#  value = ["${data.baremetal_core_vnic.ilo-poc-core1-Vnic.private_ip_address}"]
#}

output "ilo-poc-core1-PublicIP" {
  value = ["${data.baremetal_core_vnic.ilo-poc-core1-Vnic.public_ip_address}"]
}

#output "ilo-poc-data0-PrivateIP" {
#  value = ["${data.baremetal_core_vnic.ilo-poc-data0-Vnic.private_ip_address}"]
#}

output "ilo-poc-data0-PublicIP" {
  value = ["${data.baremetal_core_vnic.ilo-poc-data0-Vnic.public_ip_address}"]
}

#output "ilo-poc-data1-PrivateIP" {
#  value = ["${data.baremetal_core_vnic.ilo-poc-data1-Vnic.private_ip_address}"]
#}

output "ilo-poc-data1-PublicIP" {
  value = ["${data.baremetal_core_vnic.ilo-poc-data1-Vnic.public_ip_address}"]
}

#output "ilo-poc-haproxy-PrivateIP" {
#  value = ["${data.baremetal_core_vnic.ilo-poc-haproxy-Vnic.private_ip_address}"]
#}

output "ilo-poc-haproxy-PublicIP" {
  value = ["${data.baremetal_core_vnic.ilo-poc-haproxy-Vnic.public_ip_address}"]
}

#output "ilo-poc-pxb-PrivateIP" {
#  value = ["${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.private_ip_address}"]
#}

output "ilo-poc-pxb-PublicIP" {
  value = ["${data.baremetal_core_vnic.ilo-poc-pxb-Vnic.public_ip_address}"]
}

output "pce cluster INFO" {
  value = ["\n\t** Update your DNS records or /etc/hosts file with '${data.baremetal_core_vnic.ilo-poc-haproxy-Vnic.public_ip_address} ${var.ilo_pce_fqdn}' **\n\turl: https://${var.ilo_pce_fqdn}:8443\n\tusername: ${var.ilo_admin_user}\n\tpassword: ${var.ilo_password}\n"]
}

