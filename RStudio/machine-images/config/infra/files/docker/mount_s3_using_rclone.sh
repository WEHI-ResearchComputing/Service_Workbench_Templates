#!/usr/bin/env bash

set -ex

rclone mount \
  -vvv \
  --daemon \
  --allow-other \
  --uid 1000 \
  --gid 1000 \
  --cache-dir /root/rclone/vfs-cache-dir/ \
  --no-modtime \
  --vfs-cache-mode writes \
  ASPREE-combined:904145425705-prod-syd-sw-studydata/studies/Organization/ASPREE-combined \
  /home/rstudio/studies
