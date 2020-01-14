#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Use node lts version
source ${HOME}/.nvm/nvm.sh
nvm install --lts

# Run build scripts
node --version
npm --version
npm ci

# Compare
git status
git diff --word-diff=porcelain --exit-code
