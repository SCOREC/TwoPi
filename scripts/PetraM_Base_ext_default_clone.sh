#!/bin/bash

REPO="PetraM_Base_ext"
SRCDIR=${TwoPiRoot}/src
SC=$(dirname "$0")/subs/git_access.sh
source $SC

git_clone_or_pull "${TwoPiGit}/PetraM_Base_ext.git" $REPO $SRCDIR



