#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot

# Start the webserver.
${HOME}/build/test-dir/bin/drush runserver --default-server=builtin 0.0.0.0:8080 &>/dev/null &

# Start framebuffer.
Xvfb :99 &
export DISPLAY=:99

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    chromedriver --port=4444 --silent &

elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    geckodriver --binary /usr/bin/firefox-esr --host 127.0.0.1 --port 4444 &>/dev/null &
fi
# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}

# Fail on newly created reference images
if [ -n "$(git status --porcelain)" ]; then
  echo "Failing due to uncommited changes in repo, check your reference images."
  exit 1
fi

