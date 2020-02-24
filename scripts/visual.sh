#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot

# Start the webserver.
${HOME}/build/test-dir/bin/drush runserver --default-server=builtin 0.0.0.0:8080 &>/dev/null &

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}

# Fail on newly created reference images
if [ -n "$(git status --porcelain)" ]; then
  echo "Failing due to uncommited changes in repo, check your reference images."
  exit 1
fi

