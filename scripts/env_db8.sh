#!/bin/sh
CC=cc
CXX=c++
FC=gfortran
MPICC=mpicc
MPICXX=mpicxx
MPIFC=mpif90
MPIFL=mpif90
MAKEOPT=""
OMPFLAG="-fopenmp"
OMPLINKFLAG=-fopenmp
OMPCXXFLAG=-fopenmp
OMPCCFLAG=-fopenmp
OMPFCFLAG=-fopenmp

MYPATH=$(realpath "$0")
source $(dirname "$MYPATH")/env_common.sh
#echo $MPI_INCLUDE_PATH

