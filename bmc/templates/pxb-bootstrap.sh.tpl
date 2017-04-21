#!/bin/bash -x

# Enable root login until next reboot
cat /home/opc/.ssh/authorized_keys > /root/.ssh/authorized_keys

mkdir /etc/ansible

cat << HERE > /home/opc/.ssh/ansible-key
${ssh_private_key}
HERE

cat << HERE > /home/opc/.ssh/config
Host *
    ServerAliveInterval 60
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
    User opc
    IdentityFile /home/opc/.ssh/ansible-key
HERE

chown opc.opc /home/opc/.ssh/ansible-key
chown opc.opc /home/opc/.ssh/config

chmod 0400 /home/opc/.ssh/ansible-key
chmod 0400 /home/opc/.ssh/config

yum -y install epel-release
yum -y install ansible ansible-lint

