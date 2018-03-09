#!/bin/bash -xe

latest=$(git ls-remote --t https://github.com/drupal/core.git | grep -o 'refs/tags/[0-9]*\.[0-9]*\.[0-9]*$' | awk -F '/' '{ print $3 }' | sort -r | head -1)

branches=( $(git ls-remote -h https://github.com/drupal/core.git |awk -F '/' '{ print $3 }' | grep -e '8' | sort -r) )
tags=( "8.6.0-alpha" $(git ls-remote -t https://github.com/drupal/core.git |awk -F '/' '{ print $3 }' | grep -e '8' | sort -r))
branchesToCheck=()

for branch in "${branches[@]}"; do
    gotTag=( $(echo ${tags[@]} | grep ${branch%.x}) )
    islatest=( $(printf -- '%s\n' "${tags[@]}" | grep ${branch%.x} | grep ${latest}))
    [[ "${#gotTag}" -ne 0 ]] && branchesToCheck+=($branch)
    [[ "${#islatest}" -ne 0 ]] && break
done


[[ ${DRUPAL} = "current" ]] && DRUPAL_BRANCH=$(printf -- '%s\n' "${branchesToCheck[@]}" | tail -n1)
[[ ${DRUPAL} = "next" ]] &&  [[ "${#branchesToCheck}" > 1 ]]&& DRUPAL_BRANCH=$(printf -- '%s\n' "${branchesToCheck[@]}" | head -1)

echo "Latest drupal version is ${latest}"

if [ -n "$DRUPAL_BRANCH" ]; then
    echo "Drupal branch to check ${DRUPAL_BRANCH}"
fi