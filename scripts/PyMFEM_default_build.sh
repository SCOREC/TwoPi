#!/bin/bash

SCRIPT=$(dirname $BASH_SOURCE)/env_${TwoPiDevice}.sh
source $SCRIPT

DO_SERIAL=false
DO_PARALLEL=false
DO_DEFAULT=true

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--serial)
    DO_SERIAL=true
    DO_DEFAULT=false
    shift # past argument    
    ;;
    -p|--parallel)
    DO_PARALLELE=true
    DO_DEFAULT=false
    shift # past argument
    ;;
    --boost-root)
    BOOST_ROOT=$2
    shift # past argument
    shift # past param
    ;;
    --boost-lib)
    BOOST_LIB=$2
    shift # past argument
    shift # past param
    ;;
    --boost-inc)
    BOOST_INC=$2
    shift # past argument
    shift # past param
    ;;
    --mpi-root)
    MPI_ROOT=$2
    shift # past argument
    shift # past param
    ;;
    --mpi-lib)
    MPI_LIB=$2
    shift # past argument
    shift # past param
    ;;
    --mpi-inc)
    MPI_INC=$2
    shift # past argument
    shift # past param
    ;;
esac
done

### 
# set MPI and Booost related variable (This should happen before cd below)
source $(dirname $BASH_SOURCE)/subs/find_boost.sh
source $(dirname $BASH_SOURCE)/subs/find_mpi.sh
###

SRCDIR=${TwoPiRoot}/src
REPO=${SRCDIR}/PyMFEM

TWOPILIB=${TwoPiRoot}/lib
TWOPIINC=${TwoPiRoot}/include

MAKE=$(command -v make)
cd $REPO
touch Makefile.local

export MFEM=${TwoPiRoot}/mfem-git/par
export MFEMBUILDDIR=${TwoPiRoot}/src/mfem-git/cmbuild_par
export MFEMSER=${TwoPiRoot}/mfem-git/ser
export MFEMSERBUILDDIR=${TwoPiRoot}/src/mfem-git/cmbuild_ser
export HYPREINC=$TWOPIINC
export HYPRELIB=$TWOPILIB
export METIS5INC=$TWOPIINC
export METIS5LIB=$TWOPILIB

#MPI
if [ -z ${MPI_INC+x} ];then
    if [ -z ${MPI_ROOT+x} ];then
	export MPICHINC=${MPI_INCLUDE_PATH}
    else
	export MPICHINC=${MPI_ROOT}/include
    fi
else
   export MPICHINC=${MPI_INC}
fi
if [ -z ${MPI_LIB+x} ];then
   if [ -z ${MPI_ROOT+x} ];then
       export MPICHLNK=${MPI_LIBRARY_PATH}
   else
       export MPICHLNK=${MPI_ROOT}/lib
   fi
else
   export MPICHLNK=${MPI_LIB}
fi

#Boost
if [ -z ${BOOST_INC+x} ];then
   if [ -z ${BOOST_ROOT+x} ];then
       export BOOSTINC=${BOOST_INCLUDE_PATH}
   else
       export BOOSTINC=${BOOST_ROOT}/include
   fi
else
   export BOOSTINC=${BOOST_INC}
fi
if [ -z ${BOOST_LIB+x} ];then
    if [ -z ${BOOST_ROOT+x} ];then
       export BOOSTLIB=${BOOST_LIBRARY_PATH}
    else
	export BOOSTLIB=${BOOST_ROOT}/lib
    fi
else
   export BOOSTLIB=${BOOST_LIB}
fi

export CC=${CC}
export CXX=${CXX}
if $DO_SERIAL || $DO_DEFAULT ;then
    $MAKE ser
fi
export CC=${MPICC}
export CXX=${MPICXX}
if $DO_PARALLEL || $DO_DEFAULT ;then
    $MAKE par
fi

mkdir -p ${TwoPiRoot}/lib/python2.7/site-packages

$MAKE pyinstall PREFIX=${TwoPiRoot}
