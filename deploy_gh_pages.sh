#!/bin/bash

function deploy_gh_pages {
    mkdir -p docs
    # Build you static site here
    cp src/* docs/
    git add docs/*
    git status
    git commit -m "docs(pages): update external static site from ${CI_JOB_ID}"
    git log
    git checkout -b gh-pages public/gh-pages
    git cherry-pick -X theirs public/master
    git push
}

if [[ ! $PUBLIC_ORIGIN ]];
then
    echo "Environment variable PUBLIC_ORIGIN is not set"
    exit 1
fi

# Fetch branches from the remote public project
git remote add public $PUBLIC_ORIGIN
git fetch public
git fetch origin
git branch -a
new_commit=$(git log origin/master..public/master | wc -l)
if [ "${new_commit}" -gt 0 ]; then
    echo "New commits where found on the remote master branch, deploy pages..."
    deploy_gh_pages
else
    echo "Nothing changed in the remote repository, nothing to do."
    exit 0
fi
