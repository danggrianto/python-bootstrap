#!/bin/bash

# create folder repository
echo "enter project name :"
read project
mkdir $project
touch $project/__init__.py
git add $project
git commit -m "$project : initialize project"

# modify Makefile
sed -i "" "s/bootstrap/$project/g" Makefile
git add Makefile
git commit -m "Makefile: change module name"

# modify README.md
sed -i "" "s/bootstrap/$project/g" README.md
git add README.md
git commit -m "README: change module name"

# install requirements and freeze
make freeze
git add requirements.txt
git commit -m 'requirements: freeze requirements'


# delete bootstrap file=
git rm bootstrap.sh
git commit -m 'bootstrap: removing this file'

# git remote stuff
echo "enter remote repository url :"
read repository
git remote set-url origin $repository
git push origin master
