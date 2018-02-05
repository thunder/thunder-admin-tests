#!/usr/bin/env bash

cd ${THEME}

echo 'console.log()' >> ${THEME}/js/tabledrag.checkbox.js
# Run build scripts
node --version
npm --version
yarn

# Compare
git status
git diff --word-diff=porcelain --exit-code

# @todo Do some linting

