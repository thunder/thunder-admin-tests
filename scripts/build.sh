#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Run build scripts
node --version
npm --version
npm ci

# Compare
git status
git diff --word-diff=porcelain --exit-code
