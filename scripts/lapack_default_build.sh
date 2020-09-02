#!/bin/bash

GIT=$(command -v git)
SRCDIR=${TwoPiRoot}/src
CMAKE=$(command -v cmake)
MAKE=$(command -v make)

SCRIPT=$(dirname "$0")/env_${TwoPiDevice}.sh
source $SCRIPT

LAPACKDIR=${SRCDIR}/lapack-${LAPACK_VERSION}

export CXX=${CXX}
export CC=${CC}

mkdir -p ${LAPACDIR}/src/cmbuild
cd ${LAPACKDIR}/src/cmbuild

$CMAKE .. -DBUILD_SHARED_LIBS=1  \
          -DCMAKE_INSTALL_PREFIX=${TwoPiRoot}/lapack             

$MAKE verbose=1
$MAKE install



