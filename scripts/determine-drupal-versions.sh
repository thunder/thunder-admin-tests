#!/bin/bash

# Get latest drupal version.
# Use github mirror since http://git.drupal.org/project/drupal.git seems to fail quite often.
# Use grep since ls-remote refs patterns are f
latest=$(git ls-remote --tags https://github.com/drupal/drupal.git | grep -o 'refs/tags/[0-9]*\.[0-9]*\.[0-9]*$' | cut -d/ -f3 | sort -rV | head -1)

branches=( $(git ls-remote -h https://github.com/drupal/drupal.git 8* | cut -d/ -f3 | sort -rV) )
tags=( $(git ls-remote -t https://github.com/drupal/drupal.git 8* | cut -d/ -f3 | sort -rV))
branchesToCheck=()

# Determine which branches are eligible to be tested. Branches are ordered in a descending manner.
for branch in "${branches[@]}"; do
    gotTag=( $(echo ${tags[@]} | grep ${branch%.x}) )
    islatest=( $(printf -- '%s\n' "${tags[@]}" | grep ${branch%.x} | grep ${latest}))
    # Add branch if it got tags.
    [[ "${#gotTag}" -ne 0 ]] && branchesToCheck+=($branch)
    # Found branch corresponding to drupal latest version, break since we do not check old branches.
    [[ "${#islatest}" -ne 0 ]] && break
done

if [ "${DRUPAL}" = "current" ]; then
  DRUPAL_BRANCH=$(printf -- '%s\n' "${branchesToCheck[@]}" | tail -n1)
fi

if [ "${DRUPAL}" = "next" ];then
  [[ "${#branchesToCheck[@]}" -gt 1 ]] && export DRUPAL_BRANCH=$(printf -- '%s\n' "${branchesToCheck[@]}" | head -1)

  # Fail if there is no branch.
  [[ -z "$DRUPAL_BRANCH" ]] && echo "No tag on next version branch." && exit 1
fi

if [ -n "$DRUPAL_BRANCH" ]; then
 echo "Drupal branch to check ${DRUPAL_BRANCH}"
fi

export DRUPAL_BRANCH