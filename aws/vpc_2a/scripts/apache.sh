#!/bin/bash -e

yum -y install httpd

server_port="3600"
region="us-west-6"

cat << EOF > /var/www/html/index.html
<html>
    <head>
        <title> Hello, World </title>
    </head>
    <body>
    <p>
        Server port from shell is $${server_port}<br>
        AWS Region from shell is $${region}<br>
    </p>
    <p>
        Server port from terraform is ${server_port}<br>
        AWS Region from terraform is ${region}<br>
    </p>
    </body>
</html>
EOF

systemctl start httpd
