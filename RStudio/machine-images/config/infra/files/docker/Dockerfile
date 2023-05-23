FROM rocker/tidyverse:4.3.0

RUN apt update
RUN apt install -y \
  jq \
  curl \
  fuse

ADD https://github.com/kahing/goofys/releases/download/v0.24.0/goofys .
RUN mv goofys /usr/local/bin/goofys
RUN chmod +x /usr/local/bin/goofys

# S3 mounts rely on the host sharing the following file in the following location:
# /host/etc/s3-mounts.json
# Via a means similar to this:
# /usr/bin/docker run --privileged --rm -e PASSWORD=$(sudo cat /root/secret.txt) -p 8787:8787 --mount type=bind,source=/usr/local/,target=/host rocker_tidyverse_4.3.0_goofys:1 &
COPY ./mount_s3_wehi.sh /etc/cont-init.d/03_mount_s3
RUN chmod +x /etc/cont-init.d/03_mount_s3

COPY scripts /scripts
RUN /scripts/install_bioconductor.sh
RUN /scripts/install_paws.sh
