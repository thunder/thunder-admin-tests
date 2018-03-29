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

        git config --global user.email "technology@thunder.org"
        git config --global user.name "ThunderTechAccount"

        # Reanimate Detached HEAD repo.
        git remote set-branches origin ${TRAVIS_PULL_REQUEST_BRANCH}
        git fetch --depth 1 origin ${TRAVIS_PULL_REQUEST_BRANCH}
        git checkout ${TRAVIS_PULL_REQUEST_BRANCH}
        git remote set-url origin https://${GITHUB_TOKEN}@github.com/${TRAVIS_PULL_REQUEST_SLUG}.git

        # Setup lfs for oath token
        git config lfs.https://github.com/${TRAVIS_PULL_REQUEST_SLUG}.locksverify false
        git config lfs.https://github.com/${TRAVIS_PULL_REQUEST_SLUG}.access basic
        git config lfs.url https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${TRAVIS_PULL_REQUEST_SLUG}.git/info/lfs
        git config lfs.pushurl https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${TRAVIS_PULL_REQUEST_SLUG}.git/info/lfs

        # Commit and push.
        git status
        git commit screenshots/reference/ -m 'Updated visual reference images'
        git push
    fi
fi
