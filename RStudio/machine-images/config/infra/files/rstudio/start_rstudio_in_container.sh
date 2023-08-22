#!/bin/bash

set -ex

# 1) grab the correct published container:
# aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 010045907075.dkr.ecr.ap-southeast-2.amazonaws.com
# /usr/bin/docker pull 010045907075.dkr.ecr.ap-southeast-2.amazonaws.com/rocker_tidyverse_4.3.0:2

# 2) create container locally with:
# /usr/bin/docker run \
#   --privileged \
#   -p 8787:8787 \
#   010045907075.dkr.ecr.ap-southeast-2.amazonaws.com/rocker_tidyverse_4.3.0:2

# 3) get local container name with:
# docker container ls -a

# 4) start the local container by name:
/usr/bin/docker start pensive_wilson
