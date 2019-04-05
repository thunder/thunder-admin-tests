#!/bin/bash

if [ -n "DRUPAL_CORE" ]; then
  echo "Drupal core version has already been set to ${DRUPAL_CORE}"
  exit 1
fi

# Determine latest drupal version and dev branches.
#
# Use github mirror since http://git.drupal.org/project/drupal.git seems to fail quite often.
refs=( $(git ls-remote https://github.com/drupal/drupal.git 8*) )

# Get latest drupal 8 version.
latestVersion=$(printf -- '%s\n' ${refs[@]} | grep -o '[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)

# Get branch for current and next minor version
branchesToCheck=( $(printf -- '%s\n' "${refs[@]}" | grep -o '[0-9]*\.[0-9]*\.x$' | grep -A1 ${latestVersion%[0-9]*}x | cut -d/ -f3) )

if [ "${DRUPAL_BRANCH}" = "current" ]; then
  # Dev branch for latest drupal version.
  DRUPAL_CORE=${branchesToCheck[0]}-dev
elif [ "${DRUPAL_BRANCH}" = "next" ];then

  if [ "${#branchesToCheck}" -lt 2 ];then
    echo "No next minor version branch found." && exit 1
  else
    # Check for tags on next minov version branch.
    gotTag=( $(printf -- '%s\n' ${refs[@]} | grep refs/tags/${branchesToCheck[1]%.x} | cut -d/ -f3) )

    if [ "${#gotTag}" -ne 0 ]; then
      export DRUPAL_CORE=${branchesToCheck[1]}-dev
    else
      echo "Next minor version branch has no tags." && exit 1
    fi
  fi
fi

if [ -n "DRUPAL_CORE" ]; then
  echo "Drupal branch to check ${DRUPAL_CORE}"
fi

export DRUPAL_CORE

