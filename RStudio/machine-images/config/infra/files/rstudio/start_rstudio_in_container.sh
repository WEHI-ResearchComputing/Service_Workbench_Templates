#!/bin/bash

set -ex

pword=$(cat /root/secret.txt)
echo $pword
/usr/bin/docker run \
  --privileged \
  --rm \
  -e PASSWORD=$pword \
  -p 8787:8787 \
  --mount type=bind,source=/usr/local/,target=/host \
  010045907075.dkr.ecr.ap-southeast-2.amazonaws.com/rocker_tidyverse_4.3.0:1 \
  &
