# Secret environment variables are sourced from ~/.terraform_bmc_rc
# source ~/.terraform_bmc_rc
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "SubnetOCID" {}

# Variables from terraform.tfvars
variable "AD" {}
variable "timeout_minutes" {}
variable "InstanceShape" {}
variable "InstanceOS" {}
variable "InstanceOSVersion" {}

variable "ilo_pce_fqdn" {}
variable "ilo_venrepo_fqdn" {}
variable "ilo_package" {}
variable "ilo_admin_user" {}
variable "ilo_admin_name" {}
variable "ilo_password" {}
variable "ilo_organization" {}
