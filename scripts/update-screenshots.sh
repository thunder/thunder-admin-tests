#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

CHANGES=( $(ls screenshots/diff ) )

echo "${CHANGES[@]}"

if [[ ${UPDATE_SCREENSHOTS} != "true" ]]; then
  echo "update screenshots now"
fi

if ["${TRAVIS_EVENT_TYPE}" == "pull_request" ]; then
  echo "${TRAVIS_EVENT_TYPE}"
fi

# Set configuration
#git config --global user.email "travis@thunder.org"
#git config --global user.name "Travis CI"

