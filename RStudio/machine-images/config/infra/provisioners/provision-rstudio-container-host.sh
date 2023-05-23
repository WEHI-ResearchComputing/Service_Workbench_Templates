#!/usr/bin/env bash

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
sudo mv "/tmp/rstudio/set-password" "/usr/local/bin/"
sudo chown root: "/usr/local/bin/set-password"
sudo chmod 775 "/usr/local/bin/set-password"
sudo crontab -l 2>/dev/null > "/tmp/crontab"
sudo sh "/usr/local/bin/set-password"
echo '@reboot /usr/local/bin/set-password 2>&1 >> /var/log/set-password.log' >> "/tmp/crontab"
sudo crontab "/tmp/crontab"

# Install script that checks idle time and shuts down if max idle is reached
# sudo mv "/tmp/rstudio/check-idle" "/usr/local/bin/"
# sudo chown root: "/usr/local/bin/check-idle"
# sudo chmod 775 "/usr/local/bin/check-idle"
# sudo crontab -l 2>/dev/null > "/tmp/crontab"
# echo '*/2 * * * * /usr/local/bin/check-idle 2>&1 >> /var/log/check-idle.log' >> "/tmp/crontab"
# sudo crontab "/tmp/crontab"

sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on

sudo docker pull public.ecr.aws/h3j5s9c2/rocker_tidyverse_4-3-0_goofys_paws_bioconductor:1

sudo cp -v /tmp/rstudio/start_rstudio_in_container.sh /root/

sudo cp -v /tmp/rstudio/docker_boot.service /etc/systemd/system
sudo systemctl enable docker_boot.service
