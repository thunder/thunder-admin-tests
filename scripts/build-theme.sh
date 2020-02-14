#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Run build scripts
npm ci

# Compare
git status
git diff --word-diff=porcelain --exit-code
