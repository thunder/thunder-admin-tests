#!/bin/bash -ex


until nc -z 127.0.0.1 4444; do
    sleep 1
    if [[ ${count} -gt 10 ]]; then
        printf "Selenium timed out." 1>&2
        exit 1
    fi
    count=$((count + 1))
done

cd "${HOME}"/build/test-dir/docroot/themes/contrib/thunder_admin

# Run visual regression tests
if [[ ${UPDATE_SCREENSHOTS} == true ]]; then
  npx sharpeye --single-browser "${SHARPEYE_BROWSER}" --base-url "${BASE_URL}" --num-retries 0

else
  npx sharpeye --single-browser "${SHARPEYE_BROWSER}" --base-url "${BASE_URL}"
fi

# Fail on newly created reference images
if [ -n "$(git status --porcelain)" ]; then
    echo "Failing due to uncommited changes in repo, check your reference images."
    exit 1
fi
