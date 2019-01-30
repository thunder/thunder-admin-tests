#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}

# Fail on newly created reference images
if STATUS=$(git status --porcelain) && [ -n "$STATUS" ]; then
  echo "Failing due to uncommited changes:" 
  echo "${STATUS}"
  exit 1
fi

