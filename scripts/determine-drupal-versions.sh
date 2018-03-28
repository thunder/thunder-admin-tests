#!/bin/bash

# Get latest drupal version.
# Use github mirror since http://git.drupal.org/project/drupal.git seems to fail quite often.
# Use grep since ls-remote refs patterns are not regex.
refs=( $(git ls-remote https://github.com/drupal/drupal.git 8*) )

# Get latest drupal 8 version.
latestVersion=$(printf -- '%s\n' ${refs[@]} | grep -o '[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)

# Get branch for current and next minor version
branchesToCheck=( $(printf -- '%s\n' "${refs[@]}" | grep -A1 ${latestVersion%[0-9]*}x | cut -d/ -f3) )

if [ "${DRUPAL}" = "current" ]; then
  # Dev branch for latest drupal version.
  DRUPAL_BRANCH=${branchesToCheck[0]}
elif [ "${DRUPAL}" = "next" ];then

  if [ "${#branchesToCheck}" -lt 2 ];then
    echo "No next minor version branch found." && exit 1
  else
    # Check for tags on next minov version branch.
    gotTag=( $(printf -- '%s\n' ${refs[@]} | grep refs/tags/${branchesToCheck[1]%.x} | cut -d/ -f3) )

    if [ "${#gotTag}" -ne 0 ]; then
      export DRUPAL_BRANCH=${branchesToCheck[1]}
    else
      echo "Next minor version branch has no tags." && exit 1
    fi
  fi
fi

if [ -n "$DRUPAL_BRANCH" ]; then
  echo "Drupal branch to check ${DRUPAL_BRANCH}"
fi

export DRUPAL_BRANCH