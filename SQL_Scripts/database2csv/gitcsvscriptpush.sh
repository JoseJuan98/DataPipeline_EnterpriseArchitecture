#!/bin/sh
#This library is needed for the script

USER=$1
LREPO=$2
REPO="https://github.com/$USER/$LREPO.git"


echo $REPO
git ls-remote $REPO -q
if [ $? -eq 0 ]
  then
    git add atest_elements.csv
    git add atest_properties.csv
    git add atest_relations.csv
    git pull $LREPO master --allow-unrelated-histories
    git commit -m "committed"
    git push -u $LREPO
    echo "Commit complete"
else
  echo "Local repository does not exist, creating one"
  git init
  git add atest_elements.csv
  git add atest_properties.csv
  git add atest_relations.csv
  git commit -m "committed"
  #git remote rm $LREPO
  git remote add $LREPO $REPO
  git push -u $LREPO master
fi
