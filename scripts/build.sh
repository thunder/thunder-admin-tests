#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Use node 12
nvm install 12
nvm use 12

# Run build scripts
node --version
npm --version
npm ci

# Compare
git status
git diff --word-diff=porcelain --exit-code
