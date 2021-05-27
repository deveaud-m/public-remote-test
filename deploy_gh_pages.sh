#!/bin/bash

function deploy_gh_pages {
    git add site
    git commit -m "docs(pages): publish new version of the website"
    git subtree push --prefix site public gh-pages
}

if [[ ! $PUBLIC_ORIGIN ]];
then
    echo "Environment variable PUBLIC_ORIGIN is not set"
    exit 1
fi

# Fetch branches from the remote public project
git remote add public $PUBLIC_ORIGIN
git fetch public
git branch -a
new_commit=$(git log origin/master..public/master | wc -l)
if [ "${new_commit}" -gt 0 ]; then
    echo "New commits where found on the remote master branch, deploy pages..."
    deploy_gh_pages
else
    echo "Nothing changed in the remote repository, nothing to do."
    exit 1
fi
