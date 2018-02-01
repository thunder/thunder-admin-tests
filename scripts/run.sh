#!/usr/bin/env bash

cd ${THEME}

# Run build scripts
node --version
npm --version
yarn

# Compare
git status
git diff --word-diff=porcelain --exit-code

# @todo Do some linting

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}


