#!/bin/bash -ex

# Create thunder project
composer create-project thunder/thunder-project:3.x ${HOME}/build/test-dir --stability dev --no-interaction --no-install

if [ -n "${THUNDER}" ]; then
    cd ${HOME}/build/test-dir
    if  [ -n "${DRUPAL_CORE}" ];then
        composer require thunder/thunder-distribution:${THUNDER}-dev drupal/core:${DRUPAL_CORE} --no-update
    else
        composer require thunder/thunder-distribution:${THUNDER}-dev --no-update
    fi
fi

cd ${HOME}/build/test-dir

# Drush 8 is needed as long as there is no drush 9 command version for image-derive-all
# this actually does the 'composer install'
COMPOSER_MEMORY_LIMIT=-1 composer require drush/drush:~8.1 burdamagazinorg/image-derive-all:master@dev thunder/thunder_styleguide thunder/thunder_testing_demo:3.x-dev

# Move theme to destination
rm -rf ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin
ln -s ${HOME}/work/theme-thunder-admin/theme-thunder-admin ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Pull images (and add gitattributes otherwise images show up as modified)
echo "screenshots/reference/** filter=lfs diff=lfs merge=lfs -text" > .gitattributes
git-lfs pull

cd ${HOME}/build/test-dir/docroot

# Install thunder
${HOME}/build/test-dir/bin/drush site-install thunder --account-pass=admin --db-url="sqlite:sites/default/files/.testbasesqlite" install_configure_form.enable_update_status_module=NULL thunder_module_configure_form.install_modules_thunder_demo -y
