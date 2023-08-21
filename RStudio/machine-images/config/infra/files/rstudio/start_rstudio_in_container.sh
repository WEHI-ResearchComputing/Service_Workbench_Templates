#!/bin/bash

set -ex

# 1) create container locally with:
# pword=$(cat /root/secret.txt)
# echo $pword
# /usr/bin/docker run \
#   --privileged \
#   -e PASSWORD=$pword \
#   -p 8787:8787 \
#   --mount type=bind,source=/usr/local/,target=/host \
#   010045907075.dkr.ecr.ap-southeast-2.amazonaws.com/rocker_tidyverse_4.3.0:1

# 2) get local container name with: docker container ls -a

# 3) start the local container by name:
/usr/bin/docker start reverent_cori
