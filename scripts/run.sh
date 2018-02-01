#!/usr/bin/env bash

echo '' > ${THUNDER}/docroot/core/themes/seven/css/components/dialog.css

cd ${THEME}

# Run build scripts
node --version
npm --version
yarn

# Compare
git status
git diff --word-diff=porcelain --exit-code

# Do some linting

# Run visual regression tests
###./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}


