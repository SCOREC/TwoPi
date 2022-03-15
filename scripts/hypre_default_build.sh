#!/bin/bash

SCRIPT=$(dirname "$0")/env_${TwoPiDevice}.sh
source $SCRIPT

_usage() {
    echo 'HYPRE : parallel linear solver'
    echo '   options: --cuda (nvcc must be found on PATH)'
}

ENABLE_CUDA="NO"

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --cuda)
    ENABLE_CUDA="YES"	
    shift # past argument    	
    ;;
    --help)
    _usage
    exit 1
    ;;
    *)
    echo "Unknown option " $key
    exit 2  #  error_code=2
    ;;
esac
done

GIT=$(command -v git)
SRCDIR=${TwoPiRoot}/src
CMAKE=$(command -v cmake)
MAKE=$(command -v make)
HOST_COMPILER=$(command -v ${MPICC})

HYPREDIR=${SRCDIR}/hypre-${HYPRE_VERSION}

export CXX=${MPICXX}
export CC=${MPICC}

mkdir -p ${HYPREDIR}/src/cmbuild
cd ${HYPREDIR}/src/cmbuild

$CMAKE .. -DCMAKE_VERBOSE_MAKEFILE=1                                     \
          -DBUILD_SHARED_LIBS=1                                          \
          -DHYPRE_INSTALL_PREFIX=${TwoPiRoot}                            \
          -DHYPRE_SHARED=1                                               \
          -DHYPRE_WITH_CUDA=${ENABLE_CUDA}                               \
          -DCUDA_HOST_COMPILER=${HOST_COMPILER}                          \
          -DCMAKE_INSTALL_PREFIX=${TwoPiRoot}                            \
          -DCMAKE_INSTALL_NAME_DIR=${TwoPiRoot}/lib                            

# I am not sure if this works...
# -DCMAKE_C_COMPILER=$MPICC -DCMAKE_CXX_COMPILER=$MPICXX

$MAKE verbose=1
$MAKE install

cd $TwoPiRoot/lib
if [ -f $TwoPiRoot/lib64/libHYPRE.so ]; then
   ln -snf $TwoPiRoot/lib64/libHYPRE.so libHYPRE.so
fi



