#!/bin/bash

GIT=$(command -v git)
SRCDIR=${TwoPiRoot}/src

mkdir -p $SRCDIR
cd $SRCDIR
wget http://mumps.enseeiht.fr/MUMPS_5.1.2.tar.gz
tar -zxvf MUMPS_5.1.2.tar.gz
rm MUMPS_5.1.2.tar.gz

