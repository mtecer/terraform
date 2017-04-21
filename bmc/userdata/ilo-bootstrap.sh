#!/bin/bash -x

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

