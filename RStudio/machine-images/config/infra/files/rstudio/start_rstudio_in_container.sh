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
  public.ecr.aws/h3j5s9c2/rocker_tidyverse_4-3-0_goofys_paws_bioconductor:1 \
  &
