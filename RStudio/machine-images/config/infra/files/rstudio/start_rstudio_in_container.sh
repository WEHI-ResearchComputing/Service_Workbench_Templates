#!/bin/bash

set -ex

# 1) grab the correct published container:
# aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 010045907075.dkr.ecr.ap-southeast-2.amazonaws.com
# /usr/bin/docker pull 010045907075.dkr.ecr.ap-southeast-2.amazonaws.com/analysisenv:2

# 2) create container locally with:
# https://docs.docker.com/engine/reference/commandline/create/
# /usr/bin/docker create \
#   --privileged \
#   -p 8787:8787 \
#   -i -t \
#   --name analysisenv_2 \
#   010045907075.dkr.ecr.ap-southeast-2.amazonaws.com/analysisenv:2

# 3) start the local container by name:
/usr/bin/docker start analysisenv_2
