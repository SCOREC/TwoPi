#!/bin/bash

GIT=$(command -v git)
SRCDIR=${TwoPiRoot}/src
mkdir -p $SRCDIR

MYPATH=$(realpath "$0")
echo $MYPATH

OOCTGZ=$(dirname "$MYPATH")/../externals/opencascade-7.2.0.tar.gz

cp $OOCTGZ $SRCDIR
cd  $SRCDIR
tar -zxvf opencascade-7.2.0.tar.gz
rm $SRCDIR/opencascade-7.2.0.tar.gz
