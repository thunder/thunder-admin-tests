#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Update reference images for visual regression tests.
#
# Copy images and push to branch
if [ ${UPDATE_SCREENSHOTS} == "true" ] && [ ${TRAVIS_PULL_REQUEST}  != 'false' ]; then
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
    # Checkout branch.
    git remote set-branches origin ${TRAVIS_PULL_REQUEST_BRANCH}
    git fetch --depth 1 origin ${TRAVIS_PULL_REQUEST_BRANCH}
    git checkout ${TRAVIS_PULL_REQUEST_BRANCH}
    # Commit changes.
    git commit screenshots/screen/* -m 'TRAVIS: Updated visual reference images'
    git status
fi

