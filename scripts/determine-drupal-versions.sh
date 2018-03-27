#!/bin/bash

# Get latest drupal version.
# Use github mirror since http://git.drupal.org/project/drupal.git seems to fail quite often.
# Use grep since ls-remote refs patterns are not regex.
latestVersion=$(git ls-remote --tags https://github.com/drupal/drupal.git | grep -o 'refs/tags/[0-9]*\.[0-9]*\.[0-9]*$' | cut -d/ -f3 | tail -1 |grep '[0-9]*$')

# Get branch for current and next minor version
branchesToCheck=( $(git ls-remote -h https://github.com/drupal/drupal.git 8* | cut -d/ -f3 | grep -A1 ${latestVersion%[0-9]*}x ) )

if [ "${DRUPAL}" = "current" ]; then
  DRUPAL_BRANCH=${branchesToCheck[0]}
fi

if [ "${DRUPAL}" = "next" ] && [ "${#branchesToCheck}" -gt 1 ];then
  # Check for tags.
  gotTag=( $(git ls-remote -t https://github.com/drupal/drupal.git 8* | cut -d/ -f3 | grep ${branchesToCheck[1]%.x}) )
  [[ "${#gotTag}" -ne 0 ]] && export DRUPAL_BRANCH=${branchesToCheck[1]}

  # Fail if there is no branch.
  [[ -z "$DRUPAL_BRANCH" ]] && echo "No tag on next minor version branch." && exit 1
fi

if [ -n "$DRUPAL_BRANCH" ]; then
 echo "Drupal branch to check ${DRUPAL_BRANCH}"
fi

export DRUPAL_BRANCH