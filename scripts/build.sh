#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Use node lts version
set -x
nvm install --lts
set +x

# Run build scripts
node --version
npm --version
npm ci

# Compare
git status
git diff --word-diff=porcelain --exit-code
