#!/bin/bash

SCRIPT=$(dirname "$0")/env_${TwoPiDevice}.sh
source $SCRIPT

_usage() {
    echo 'MFEM : parallel build (with metis/hypre)'
    echo '   options: --cuda (nvcc must be found on PATH)'
}

SRCDIR=${TwoPiRoot}/src
REPO=${SRCDIR}/mfem
TWOPILIB=${TwoPiRoot}/lib
TWOPIINC=${TwoPiRoot}/include

CMAKE=$(command -v cmake)
MAKE=$(command -v make)
HOST_COMPILER=$(command -v ${MPICXX})

cd $REPO

echo "############# configuring mfem parallel"

mkdir -p $REPO/cmbuild_par
cd $REPO/cmbuild_par
rm -rf $REPO/cmbuild_par/*

WITH_PUMI=NO
WITH_SUITESPARSE=NO
ENABLE_CUDA=NO

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --with-pumi)
    WITH_PUMI=YES
    shift # past argument    
    ;;
    --with-suitesparse)
    WITH_SUITESPARSE=YES
    shift # past argument
    ;;
    --cuda)
    ENABLE_CUDA="YES"
    shift # past argument    	
    ;;
    *)
    echo "Unknown option " $key
    exit 2  #  error_code=2
    ;;
esac
done

echo cuda"${ENABLE_CUDA}"

$CMAKE .. -DCMAKE_VERBOSE_MAKEFILE=1                           \
          -DBUILD_SHARED_LIBS=1                                \
          -DMFEM_ENABLE_EXAMPLES=1                             \
          -DCMAKE_INSTALL_PREFIX=${TwoPiRoot}/mfem/par         \
          -DHYPRE_DIR=$TWOPILIB                                \
	  -DHYPRE_INCLUDE_DIRS=$TWOPIINC                       \
          -DMETIS_DIR=$TWOPILIB                                \
	  -DMETIS_INCLUDE_DIRS=$TWOPIINC                       \
          -DMFEM_USE_ZLIB=1                                    \
          -DMFEM_USE_MPI=1                                     \
	  -DMFEM_USE_METIS_5=1                                 \
	  -DMFEM_USE_CUDA="${ENABLE_CUDA}"                     \
          -DCMAKE_CUDA_HOST_COMPILER="${HOST_COMPILER}"        \
	  -DMFEM_ENABLE_EXAMPLES=1                             \
          -DMFEM_USE_PUMI="${WITH_PUMI}"                       \
 	  -DPUMI_DIR="${TwoPiRoot}"                            \
          -DMFEM_USE_SUITESPARSE="${WITH_SUITESPARSE}"         \
          -DSuiteSparse_DIR="${TwoPiRoot}"                     \
          -DCMAKE_CXX_COMPILER=$MPICXX                         \
          -DCMAKE_CXX_FLAGS=$CXX11FLAG                         \
	  -DCMAKE_SHARED_LINKER_FLAGS="-L$TWOPILIB"            \
	  -DCMAKE_EXE_LINKER_FLAGS="-L$TWOPILIB"               \
          -DCMAKE_CXX_STANDARD_LIBRARIES="-lHYPRE -lmetis"
$MAKE $MAKEOPT
$MAKE install

