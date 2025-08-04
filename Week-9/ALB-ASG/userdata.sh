#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo su
echo "<h1>This message from yt webserver : $(hostname)</h1>" > /var/www/html/index.html