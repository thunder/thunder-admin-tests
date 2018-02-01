#!/usr/bin/env bash

cd ${THEME}

# Run build scripts
yarn

# Compare
git status
git diff --word-diff=porcelain

# Do some linting

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}


