#!/usr/bin/env bash

# al2023-ami-2023.1.20230725.0-kernel-6.1-x86_64
# amazon/al2023-ami-2023.1.20230725.0-kernel-6.1-x86_64


# amazon/amzn2-ami-kernel-5.10-hvm-2.0.20230727.0-x86_64-gp2
# amzn2-ami-kernel-5.10-hvm-2.0.20230727.0-x86_64-gp2
sudo yum update -y
mkdir /tmp/rstudio
vim /tmp/rstudio/nginx.conf
vim /tmp/rstudio/secret.txt # ensure one line only
# [ec2-user@ip-172-31-11-10 ~]$ cat /tmp/rstudio/secret.txt
# 9w--password--uV
# [ec2-user@ip-172-31-11-10 ~]$
vim /tmp/rstudio/start_rstudio_in_container.sh
vim /tmp/rstudio/docker_boot.service

# Generate self signed certificate
commonname=$(uname -n)
password=dummypassword
mkdir -p "/tmp/rstudiov2/ssl"
chmod 700 /tmp/rstudiov2/ssl
cd /tmp/rstudiov2/ssl
openssl genrsa -des3 -passout pass:$password -out cert.key 2048
# Remove passphrase from the key. Comment the line out to keep the passphrase
openssl rsa -in cert.key -passin pass:$password -out cert.key
openssl req -new -key cert.key -out cert.csr -passin pass:$password \
    -subj "/C=NA/ST=NA/L=NA/O=NA/OU=SWB/CN=$commonname/emailAddress=example.com"
openssl x509 -req -days 365 -in cert.csr -signkey cert.key -out cert.pem
cd "../../.."

# Install and configure nginx
sudo amazon-linux-extras install -y nginx1
sudo openssl dhparam -out "/etc/nginx/dhparam.pem" 2048
sudo mv "/tmp/rstudiov2/ssl/cert.pem" "/etc/nginx/"
sudo mv "/tmp/rstudiov2/ssl/cert.key" "/etc/nginx/"
sudo mv "/tmp/rstudio/nginx.conf" "/etc/nginx/"
sudo chown -R nginx:nginx "/etc/nginx"
sudo chmod -R 600 "/etc/nginx"
sudo systemctl enable nginx
sudo systemctl restart nginx

# Install script that sets the service workbench user password at boot
sudo mv "/tmp/rstudio/secret.txt" "/root/"
sudo chown root: "/root/secret.txt"
sudo chmod 600 "/root/secret.txt"

# sudo mv "/tmp/rstudio/set-password" "/usr/local/bin/"
# sudo chown root: "/usr/local/bin/set-password"
# sudo chmod 775 "/usr/local/bin/set-password"
# sudo crontab -l 2>/dev/null > "/tmp/crontab"
# sudo sh "/usr/local/bin/set-password"
# echo '@reboot /usr/local/bin/set-password 2>&1 >> /var/log/set-password.log' >> "/tmp/crontab"
# sudo crontab "/tmp/crontab"

# Install script that checks idle time and shuts down if max idle is reached
# sudo mv "/tmp/rstudio/check-idle" "/usr/local/bin/"
# sudo chown root: "/usr/local/bin/check-idle"
# sudo chmod 775 "/usr/local/bin/check-idle"
# sudo crontab -l 2>/dev/null > "/tmp/crontab"
# echo '*/2 * * * * /usr/local/bin/check-idle 2>&1 >> /var/log/check-idle.log' >> "/tmp/crontab"
# sudo crontab "/tmp/crontab"

sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on

image_tag=1
image_name=rocker_tidyverse_4.3.0
aws_account_location=010045907075.dkr.ecr.ap-southeast-2.amazonaws.com
name_and_tag=$image_name:$image_tag
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $aws_account_location
sudo docker pull $aws_account_location/$image_name:$image_tag

sudo cp -v /tmp/rstudio/start_rstudio_in_container.sh /root/
sudo chmod +x /root/start_rstudio_in_container.sh

sudo cp -v /tmp/rstudio/docker_boot.service /etc/systemd/system
sudo systemctl enable docker_boot.service
