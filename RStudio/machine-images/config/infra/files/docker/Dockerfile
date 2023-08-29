FROM docker.io/ahmohamed/analysisenv:master

RUN apt update
RUN apt install -y \
  jq \
  curl \
  fuse3

# ADD https://downloads.rclone.org/v1.63.1/rclone-v1.63.1-linux-amd64.zip .
COPY ./rclone-v1.63.1-linux-amd64.zip .
RUN unzip rclone-v1.63.1-linux-amd64.zip
RUN cp rclone-v1.63.1-linux-amd64/rclone /usr/bin/
RUN chown root:root /usr/bin/rclone
RUN chmod 755 /usr/bin/rclone

RUN mkdir -p /home/rstudio/studies
RUN chown rstudio:rstudio /home/rstudio/studies

RUN mkdir -p /root/rclone/vfs-cache-dir/
RUN mkdir -p /root/.config/rclone/
COPY ./rclone.conf /root/.config/rclone/rclone.conf
COPY ./mount_s3_using_rclone.sh /etc/cont-init.d/03_mount_s3
RUN chmod +x /etc/cont-init.d/03_mount_s3

COPY scripts /scripts
# RUN /scripts/install_bioconductor.sh
RUN /scripts/install_paws.sh

ARG SET_PASSWORD_TO
ENV PASSWORD=$SET_PASSWORD_TO
