#!/bin/bash

SRCDIR=${TwoPiRoot}/src
REPO=${SRCDIR}/PetraM_Base
MAKE=$(command -v make)

cd $REPO

rm -rf build/*

