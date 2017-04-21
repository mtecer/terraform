[core]
core0 ansible_host=${ilo-poc-core0} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key"
core1 ansible_host=${ilo-poc-core1} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key"

[data]
data0 ansible_host=${ilo-poc-data0} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key"
data1 ansible_host=${ilo-poc-data1} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key"

[haproxy]
haproxy ansible_host=${ilo-poc-haproxy} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key"

[pxb]
pxb ansible_host=${ilo-poc-pxb} ansible_user=opc ansible_private_key_file="/home/opc/.ssh/ansible-key"
