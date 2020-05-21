#!/bin/sh

cd /home/dani/WebstormProjects/Project_D24_Bergen-Kommune/SQL_Scripts/database2csv

USER=$1
LREPO=$2
REPO="https://github.com/$USER/$LREPO.git"
if [ -d "$LREPO" ]; then
  echo "Directory exists, pulling"
  git pull $LREPO master --allow-unrelated-histories
else
  git clone $REPO
  #git remote add $LREPO $REPO
  git remote add "https://$USER:password@github.com/$USER/$LREPO.git"
fi
