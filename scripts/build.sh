#!/usr/bin/env bash

cd ${HOME}/builds/thunder/docroot/themes/contrib/thunder_admin

# Run build scripts
node --version
npm --version
yarn

# Compare
git status
git diff --word-diff=porcelain --exit-code

# @todo Do some linting

