# i-019bd3ea14d35bd5d (from-base-that-connects)
# ami-06c12e28e2b9c7548 (connects)
# 904145425705/R_v4-3-0_RStudio_v1-4-717_Bioconductor_v3-9


mkdir /tmp/rstudio

vim /tmp/rstudio/nginx.conf
vim /tmp/rstudio/start_rstudio_in_container.sh
vim /tmp/rstudio/docker_boot.service

# [root@ip-172-31-7-73 ec2-user]# crontab -l
# @reboot /usr/local/bin/set-password 2>&1 >> /var/log/set-password.log
# */2 * * * * /usr/local/bin/check-idle 2>&1 >> /var/log/check-idle.log
# [root@ip-172-31-7-73 ec2-user]# crontab -r
# [root@ip-172-31-7-73 ec2-user]# crontab -l
# no crontab for root
# [root@ip-172-31-7-73 ec2-user]#
sudo crontab -r

sudo systemctl stop rstudio-server
sudo systemctl disable rstudio-server
sudo yum remove rstudio-server -y


sudo systemctl stop nginx
sudo systemctl disable nginx
sudo mv "/etc/nginx/nginx.conf" "/etc/nginx/nginx_conf_orig"
sudo mv "/tmp/rstudio/nginx.conf" "/etc/nginx/"
sudo chown -R nginx:nginx "/etc/nginx"
sudo chmod -R 600 "/etc/nginx"
sudo systemctl enable nginx
sudo systemctl restart nginx


sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on

sudo docker pull public.ecr.aws/h3j5s9c2/rocker_tidyverse_4-3-0_goofys_paws_bioconductor:1

sudo cp -v /tmp/rstudio/start_rstudio_in_container.sh /root/
sudo chmod +x /root/start_rstudio_in_container.sh

sudo cp -v /tmp/rstudio/docker_boot.service /etc/systemd/system
sudo systemctl enable docker_boot.service
