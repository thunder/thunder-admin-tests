#!/bin/bash

# Get latest drupal version.
# Use github mirror since http://git.drupal.org/project/drupal.git seems to fail quite often.
# Use grep since ls-remote refs patterns are not regex.
refs=( $(git ls-remote https://github.com/drupal/drupal.git 8*) )

# Get latest durpal 8 version.
latestVersion=$(printf -- '%s\n' ${refs[@]} | grep -o '[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)

# Get branch for current and next minor version
branchesToCheck=( $(printf -- '%s\n' "${refs[@]}" | grep -A1 ${latestVersion%[0-9]*}x | cut -d/ -f3) )

if [ "${DRUPAL}" = "current" ]; then
  DRUPAL_BRANCH=${branchesToCheck[0]}
elif [ "${DRUPAL}" = "next" ] && [ "${#branchesToCheck}" -gt 1 ];then
  # Check for tags.
  gotTag=( $(printf -- '%s\n' ${refs[@]} | grep refs/tags/${branchesToCheck[0]%.x} | cut -d/ -f3) )
  [[ "${#gotTag}" -ne 0 ]] && export DRUPAL_BRANCH=${branchesToCheck[1]}
fi

if [ -n "$DRUPAL_BRANCH" ]; then
  echo "Drupal branch to check ${DRUPAL_BRANCH}"
else
  echo "No branch found." && exit 1
fi

export DRUPAL_BRANCH