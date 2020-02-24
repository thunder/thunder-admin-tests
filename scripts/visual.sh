#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot

# Start the webserver.
${HOME}/build/test-dir/bin/drush runserver --default-server=builtin 0.0.0.0:8080 &>/dev/null &

if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    # Pin chrome.
    docker run -d -p 4444:4444 --shm-size 2g --net=host selenium/standalone-chrome:3.141.59-zinc
elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    # Use firefox 68 (nearest to Firefox Quantum 68 ESR).
    docker run -d -p 4444:4444 --shm-size 2g --net=host selenium/standalone-firefox:3.141.59-titanium
fi

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}

# Fail on newly created reference images
if [ -n "$(git status --porcelain)" ]; then
  echo "Failing due to uncommited changes in repo, check your reference images."
  exit 1
fi

