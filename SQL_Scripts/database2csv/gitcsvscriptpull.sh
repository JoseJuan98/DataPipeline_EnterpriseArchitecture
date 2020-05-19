#!/bin/sh

P="/home/dani/WebstormProjects/Project_D24_Bergen-Kommune/SQL_Scripts/database2csv"
USER=$1
LREPO=$2
REPO="git@github.com/$USER/$LREPO.git"
if [ -d "$P/$LREPO" ]; then
  echo "Directory exists, pulling"
  git pull $LREPO master --allow-unrelated-histories
else
  git clone $REPO
  git remote add $LREPO $REPO
fi

