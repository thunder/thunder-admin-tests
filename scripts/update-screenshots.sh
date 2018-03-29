#!/bin/bash -ex

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Update reference images for visual regression tests.
#
# Copy images and push to branch
if [ ${UPDATE_SCREENSHOTS} == "true" ] && [ ${TRAVIS_PULL_REQUEST}  != 'false' ]; then
    CHANGES=( $(ls /tmp/sharpeye/${TRAVIS_JOB_ID}/diff ) )

    if [ "${#CHANGES}" > 0 ]; then

        git clone https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${TRAVIS_PULL_REQUEST_SLUG}.git -b ${TRAVIS_PULL_REQUEST_BRANCH} update
        cd update
        echo "screenshots/reference/** filter=lfs diff=lfs merge=lfs -text" > .gitattributes
        git-lfs pull

        for SCREENSHOT in "${CHANGES[@]}"
        do
            cp /tmp/sharpeye/${TRAVIS_JOB_ID}/screen/${SCREENSHOT} ./screenshots/reference/
        done

        git status
        git commit screenshots/reference/ -m 'Updated visual reference images'
        git push
    fi
fi
