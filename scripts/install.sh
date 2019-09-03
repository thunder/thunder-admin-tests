#!/bin/bash -ex

# Create thunder project
composer create-project burdamagazinorg/thunder-project:2.x ${HOME}/build/test-dir --stability dev --no-interaction --no-install

if [ -n "${THUNDER}" ]; then
    cd ${HOME}/build/test-dir
    if  [ -n "${DRUPAL_CORE}" ];then
        composer require burdamagazinorg/thunder:${THUNDER}-dev drupal/core:${DRUPAL_CORE} --no-update
    else
        composer require burdamagazinorg/thunder:${THUNDER}-dev --no-update
    fi
fi

cd ${HOME}/build/test-dir

# Temporary fix for mink dependency. Has to be removed, if drupal core has sorted this out.
# See: https://www.drupal.org/project/drupal/issues/3078671
composer require "behat/mink-selenium2-driver:1.4.x-dev as 1.3.x-dev" --dev --no-update

# Drush 8 is needed as long as there is no drush 9 command version for image-derive-all
# this actually does the 'composer install'
composer require drush/drush:~8.1 burdamagazinorg/image-derive-all:master@dev thunder/thunder_styleguide

# Move theme to destination
rm -rf ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin
mv ${HOME}/build/BurdaMagazinOrg/theme-thunder-admin ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Pull images (and add gitattributes otherwise images show up as modified)
echo "screenshots/reference/** filter=lfs diff=lfs merge=lfs -text" > .gitattributes
git-lfs pull

cd ${HOME}/build/test-dir/docroot

# Install thunder
${HOME}/build/test-dir/bin/drush site-install thunder --account-pass=admin --db-url=mysql://travis@127.0.0.1/drupal install_configure_form.enable_update_status_module=NULL -y
