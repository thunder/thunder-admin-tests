#!/usr/bin/env bash

cd ${THEME}

echo '.ui-dialog .ui-widget-content.ui-dialog-content{background:#fff;}' >> ${THUNDER}/docroot/core/themes/seven/css/components/dialog.css

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


