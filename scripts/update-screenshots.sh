#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

if [ ${UPDATE_SCREENSHOTS} == "true" ] && [ ${TRAVIS_PULL_REQUEST}  == 'true' ]; then
    CHANGES=( $(ls /tmp/sharpeye/${TRAVIS_JOB_ID}/diff ) )

    if [ "${#CHANGES}" > 0 ]; then
        for SCREENSHOT in "${CHANGES[@]}"
        do
            cp /tmp/sharpeye/${TRAVIS_JOB_ID}/screen/${SCREENSHOT} ./screenshots/reference/
        done
    fi

    git status
    # Set configuration.
    git config --global user.email "travis@thunder.org"
    git config --global user.name "Travis CI"
    # checkout branch.
    git checkout ${TRAVIS_PULL_REQUEST_BRANCH}
    # Commit changes.
    git commit screenshots/screen/* -m 'TRAVIS: Updated visual reference images'
    git status
fi

