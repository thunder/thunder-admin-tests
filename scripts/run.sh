#!/usr/bin/env bash

cd ${THEME}

# Compile css
yarn run styles

# Compare
git diff --word-diff=porcelain

# Do some linting
yarn run js


# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}


