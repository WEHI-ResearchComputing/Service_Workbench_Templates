#!/bin/bash

set -e

R -q -e "BiocManager::install('limma')"
echo -e "\nInstalled limma..."
