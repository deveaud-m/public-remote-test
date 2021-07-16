#!/bin/bash

git fetch public
git branch -a
new_commit=$(git log origin/main..public/main | wc -l)
if [ "${new_commit}" -gt 0 ]; then 
    echo "New commits where found on the remote master branch, build and deploy new website"
    git merge public/main
    git push -u origin main
else
    echo "No new commits where found on the remote master branch, exit pipeline"
fi