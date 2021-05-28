#!/bin/bash

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
    echo "New commits where found on the remote master branch, deploy pages from job ${CI_JOB_ID}"
    git checkout -b deploy origin/deploy
    # Build your mkdocs site
    poetry run mkdocs build -d docs/
    git add docs/*
    git commit -m "docs(pages): update external static site from ${CI_JOB_ID}"
    git checkout -b gh-pages public/gh-pages
    git merge -X theirs deploy
    git push
else
    echo "Nothing changed on the remote repository, nothing to do."
    exit 0
fi
