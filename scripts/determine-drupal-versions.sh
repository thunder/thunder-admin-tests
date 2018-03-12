#!/bin/bash -e
latest=$(git ls-remote --t https://github.com/drupal/core.git | grep -o 'refs/tags/[0-9]*\.[0-9]*\.[0-9]*$' | awk -F '/' '{ print $3 }' | sort -r | head -1)

branches=( $(git ls-remote -h https://github.com/drupal/core.git |awk -F '/' '{ print $3 }' | grep -e '8' | sort -r) )
tags=( $(git ls-remote -t https://github.com/drupal/core.git |awk -F '/' '{ print $3 }' | grep -e '8' | sort -r))
branchesToCheck=()

for branch in "${branches[@]}"; do
    gotTag=( $(echo ${tags[@]} | grep ${branch%.x}) )
    islatest=( $(printf -- '%s\n' "${tags[@]}" | grep ${branch%.x} | grep ${latest}))
    [[ "${#gotTag}" -ne 0 ]] && branchesToCheck+=($branch)
    [[ "${#islatest}" -ne 0 ]] && break
done

if [ "${DRUPAL}" = "current" ]; then
  DRUPAL_BRANCH=$(printf -- '%s\n' "${branchesToCheck[@]}" | tail -n1)
fi

if [ "${DRUPAL}" = "next" ];then
  [[ "${#branchesToCheck[@]}" -gt 1 ]] && DRUPAL_BRANCH=$(printf -- '%s\n' "${branchesToCheck[@]}" | head -1)

  # Fail if there is no branch.
  [[ -z "$DRUPAL_BRANCH" ]] && echo "No tag on next version branch." && exit 1
fi

[[ -n "$DRUPAL_BRANCH" ]] && echo "Drupal branch to check ${DRUPAL_BRANCH}"
echo "Latest drupal version is ${latest}"
exit 0
