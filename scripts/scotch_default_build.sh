#!/bin/bash

GIT=$(command -v git)
CMAKE=$(command -v cmake)
MAKE=$(command -v make)
SRCDIR=${TwoPiRoot}/src

# load env
SCRIPT=$(dirname "$0")/env_${TwoPiDevice}.sh
source $SCRIPT

REPO=${SRCDIR}/scotch_${SCOTCH_VERSION}

MYPATH=$BASH_SOURCE
echo $MYPATH

MAKEINC=$(dirname "$MYPATH")/../extra/scotch/scotch_${TwoPiDevice}_Makefile.inc
if [ ! -f $MAKEINC ]; then
   MAKEINC=$(dirname "$MYPATH")/../extra/scotch/scotch_default_Makefile.inc
fi
cp $MAKEINC ${REPO}/src/Makefile.inc
cd ${REPO}/src

CCD="$CC -I$MPI_INCLUDE_PATH"
echo ${CCD}
$MAKE scotch CCS="$CC" CCP="$MPICC" CCD="$CCD"
$MAKE ptscotch CCS="$CC" CCP="$MPICC" CCD="$CCD"
$MAKE install prefix="$TwoPiRoot"

CMAKELIST=$(dirname "$MYPATH")/../extra/scotch/CMakeLists.txt
cp $CMAKELIST ${REPO}/src/CMakeLists.txt
mkdir -p ${REPO}/src/cmbuild
cd ${REPO}/src/cmbuild
cmake .. -DCMAKE_INSTALL_NAME_DIR=${TwoPiRoot}/lib -DCMAKE_INSTALL_PREFIX=${TwoPiRoot}

make VERBOSE=1
make install
