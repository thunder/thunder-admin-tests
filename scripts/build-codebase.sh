#!/bin/bash -ex

# Create thunder project
composer create-project "${PROJECT}":"${PROJECT_BRANCH}" "${HOME}"/build/test-dir --stability dev --no-interaction --no-install

if [ -n "${PROFILE_BRANCH}" ]; then
    cd "${HOME}"/build/test-dir
    if [ -n "${DRUPAL_CORE}" ]; then
        composer require "${PROFILE}":"${PROFILE_BRANCH}"-dev drupal/core:"${DRUPAL_CORE}" --no-update
    else
        composer require "${PROFILE}":"${PROFILE_BRANCH}"-dev --no-update
    fi
fi

cd "${HOME}"/build/test-dir

# Drush 8 is needed as long as there is no drush 9 command version for image-derive-all
# this actually does the 'composer install'
COMPOSER_MEMORY_LIMIT=-1 composer require drush/drush:~8.1 burdamagazinorg/image-derive-all:master@dev thunder/thunder_styleguide:1.x-dev thunder/thunder_testing_demo:"${THUNDER_TESTING_DEMO_BRANCH}"-dev

# Move theme to destination
rm -rf "${HOME}"/build/test-dir/docroot/themes/contrib/thunder_admin
ln -s "${HOME}"/work/theme-thunder-admin/theme-thunder-admin "${HOME}"/build/test-dir/docroot/themes/contrib/thunder_admin

cd "${HOME}"/build/test-dir/docroot/themes/contrib/thunder_admin
