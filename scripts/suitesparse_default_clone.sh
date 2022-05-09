#!/bin/bash

# load env
SCRIPT=$(dirname "$0")/env_${TwoPiDevice}.sh
source $SCRIPT

GIT=$(command -v git)
SRCDIR=${TwoPiRoot}/src
mkdir -p $SRCDIR
cd $SRCDIR
FILE=v${SUITESPARSE_VERSION}.tar.gz
wget https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/${FILE}
tar -zxvf ${FILE}
rm ${FILE}