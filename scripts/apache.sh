#!/bin/bash -e

yum -y install httpd

server_port="3600"
region="us-west-6"

#(
#echo "Hello, World<\br>"
#echo "Server port is $${server_port}<\br>"
#echo "AWS Region is $${region}<\br>"
#echo "Server port  is ${server_port}<\br>"
#echo "AWS Region 2 is ${region}<\br>"
#) > /var/www/html/index.html


cat << EOF > /var/www/html/index.html
<html>
    <head>
        <title> Hello, World </title>
    </head>
    <body>
    <p>
        Server port from shell is \$${server_port}<br>
        AWS Region from shell is \$${region}<br>
    </p>
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

