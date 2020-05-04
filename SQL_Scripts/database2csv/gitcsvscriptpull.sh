#!/bin/sh
#This library is needed for the script

USER=$1
LREPO=$2
REPO="https://github.com/$USER/$LREPO.git"
if [ -d "$LREPO" ]; then
  echo "Directory exists, pulling"
  git pull $LREPO master --allow-unrelated-histories
else
  git clone $REPO
  git remote add $LREPO $REPO
fi
