#!/bin/bash

set -e

NCPUS=${NCPUS:--1}
install2.r --error --skipinstalled -n "$NCPUS" paws
echo -e "\nInstalled paws..."
