#!/bin/bash

SRCDIR=${TwoPiRoot}/src
REPO=${SRCDIR}/PUMI
MAKE=$(command -v make)

SCRIPT=$(dirname "$0")/env_${TwoPiDevice}.sh
source $SCRIPT

cd $REPO
mkdir -p cmbuild
cd $REPO/cmbuild

export PetraM=${TwoPiRoot}

DO_TEST=false
# ENABLE_SIMMETRIX=OFF
# ENABLE_PARASOLID=OFF
# SIMMETRIX_LIB_DIR=''
# SIMMETRIX_MPI=openmpi
ENABLE_PYTHON=OFF
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --with-test)
    DO_TEST=true
    shift # past argument    
    ;;
    --with-simmetrix)
    ENABLE_SIMMETRIX=ON
    ENABLE_PARASOLID=ON
    ENABLE_FPP=ON
    shift # past argument    
    ;;
    --simmetrix-lib)
    SIMMETRIX_LIB_DIR=$2
    shift # past argument
    shift # past argument
    ;;
    --simmetrix-mpi)
    SIMMETRIX_MPI=$2
    shift # past argument
    shift # past argument
    ;;
    --with-python)
    ENABLE_PYTHON=ON
    shift
    shift
    ;;
    *)
    echo "Unknown option " $key
    exit 2  #  error_code=2
    ;;
esac
done

# export LIBRARY_PATH=/opt/SimModSuite/15.0-191017dev/lib:$LIBRARY_PATH
# export CPATH=/opt/SimModSuite/15.0-191017dev/include:$CPATH

# export LD_LIBRARY_PATH=/opt/SimModSuite/15.0-191017dev/lib:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/SimModSuite/15.0-191017dev/lib/acisKrnl
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/SimModSuite/15.0-191017dev/lib/psKrnl

# export CMAKE_PREFIX_PATH=/opt/SimModSuite/15.0-191017dev/:$CMAKE_PREFIX_PATH
# export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/opt/SimModSuite/15.0-191017dev/lib
# export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/opt/SimModSuite/15.0-191017dev/lib/acisKrnl
# export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/opt/SimModSuite/15.0-191017dev/lib/psKrnl

# export SIMMETRIX_SIMMODSUITE_ROOT=/opt/SimModSuite/15.0-191017dev/
# export SIM_LICENSE_FILE=/home/shiraiwa/.simmetrix/MIT_Shiraiwa_2019

if $DO_TEST ;then
    cmake .. -DSCOREC_CXX_WARNINGS=OFF   \
             -DCMAKE_C_COMPILER="${MPICC}"    \
             -DCMAKE_CXX_COMPILER="${MPICXX}" \
             -DPUMI_FORTRAN_INTERFACE=OFF   \
	     -DSCOREC_CXX_OPTIMIZE=ON       \
             -DSCOREC_CXX_WARNINGS=OFF       \
             -DCMAKE_INSTALL_PREFIX="${TwoPiRoot}" \
             -DBUILD_SHARED_LIBS=on   \
             -DMDS_ID_TYPE=long \
             -DCMAKE_VERBOSE_MAKEFILE=1 \
             -DIS_TESTING=ON \
             -DBUILD_EXES=ON \
	     -DENABLE_SIMMETRIX="${ENABLE_SIMMETRIX}" \
             -DSIM_PARASOLID="${ENABLE_PARASOLID}"   \
             -DSIM_MPI="${SIMMETRIX_MPI}" \
             -DSIMMETRIX_LIB_DIR="${SIMMETRIX_LIB_DIR}"  \
             -DENABLE_FPP="${ENABLE_FPP}" \
             -DPUMI_PYTHON_INTERFACE="${ENABLE_PYTHON}" \
             -DMESHES="${TwoPiRoot}"/src/PUMI-MESHES \
             -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-no-as-needed" \
             -DCMAKE_EXE_LINKER_FLAGS="-Wl,-no-as-needed" \
             -DCMAKE_BUILD_TYPE="Debug"
else
    cmake .. -DSCOREC_CXX_WARNINGS=OFF   \
             -DCMAKE_C_COMPILER="${MPICC}"    \
             -DCMAKE_CXX_COMPILER="${MPICXX}" \
             -DPUMI_FORTRAN_INTERFACE=OFF   \
             -DSCOREC_CXX_OPTIMIZE=ON       \
             -DSCOREC_CXX_WARNINGS=OFF       \
             -DCMAKE_INSTALL_PREFIX="${TwoPiRoot}" \
             -DBUILD_SHARED_LIBS=on   \
             -DMDS_ID_TYPE=long \
             -DIS_TESTING=OFF \
             -DBUILD_EXES=OFF \
             -DSIM_MPI="${SIMMETRIX_MPI}" \
             -DENABLE_SIMMETRIX="${ENABLE_SIMMETRIX}" \
             -DSIM_PARASOLID="${ENABLE_PARASOLID}"   \
             -DSIMMETRIX_LIB_DIR="${SIMMETRIX_LIB_DIR}"  \
             -DENABLE_FPP="${ENABLE_FPP}"   \
             -DPUMI_PYTHON_INTERFACE="${ENABLE_PYTHON}" \
             -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-no-as-needed" \
             -DCMAKE_EXE_LINKER_FLAGS="-Wl,-no-as-needed" \
             -DCMAKE_VERBOSE_MAKEFILE=1
fi
echo "${MAKEOPT}"
make install

# add link to pyCore.py. it seems like there is two possible locations
PYTHON=$TwoPiRoot/bin/python
PYTHONVERSION=$(${PYTHON} -c "import os;print(os.path.basename(os.path.dirname(os.__file__))[-3:])")
cd $TwoPiRoot/lib/python${PYTHONVERSION}/site-packages

if [ -L pyCore.py ] ; then
    echo "removing previous link to pyCore.py"
    rm pyCore.py
fi
if [ -e pyCore.py ]; then
    echo "(error) pyCore.py already exits under site-packages"
    exit 1
fi

if [ -f $TwoPiRoot/lib/pyCore.py ]; then
   ln -snf $TwoPiRoot/lib/pyCore.py pyCore.py
   ln -snf $TwoPiRoot/lib/_pyCore.so _pyCore.so
fi
if [ -f $TwoPiRoot/lib64/pyCore.py ]; then
   ln -snf $TwoPiRoot/lib64/pyCore.py pyCore.py
   ln -snf $TwoPiRoot/lib64/_pyCore.so _pyCore.so
fi
