#!/usr/bin/env bash

cd ${THEME}

echo '.ui-dialog .ui-widget-content.ui-dialog-content{background:#aaa;}' >> ${THUNDER}/docroot/core/themes/seven/css/components/dialog.css

# Run build scripts
node --version
npm --version
yarn

# Compare
git status
git diff --word-diff=porcelain --exit-code

# @todo Do some linting

