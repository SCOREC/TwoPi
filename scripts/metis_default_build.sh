#!/bin/bash
SCRIPT=$(dirname "$0")/env_${TwoPiDevice}.sh
source $SCRIPT

GIT=$(command -v git)
SRCDIR=${TwoPiRoot}/src
CMAKE=$(command -v cmake)
MAKE=$(command -v make)

cd ${SRCDIR}/metis-5.1.0

$MAKE config shared=1 prefix=$TwoPiRoot cc=${CC}
$MAKE $MAKEOPT
$MAKE install

if [ "${TwoPiDevice}" == "brew" ]; then
   install_name_tool -id ${TwoPiRoot}/lib/libmetis.dylib ${TwoPiRoot}/lib/libmetis.dylib
fi



