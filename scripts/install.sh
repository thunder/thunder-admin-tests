#!/bin/bash -ex

# Create thunder project
composer create-project burdamagazinorg/thunder-project:2.x ${HOME}/build/test-dir --stability dev --no-interaction --no-install

if [ ${THUNDER} = "develop" ] && [ -n "$DRUPAL_BRANCH" ]; then
    cd ${HOME}/build/test-dir

    composer require burdamagazinorg/thunder:dev-develop drupal/core:${DRUPAL_BRANCH}-dev
fi

cd ${HOME}/build/test-dir

# Drush 8 is needed as long as there is no drush 9 command version for image-derive-all
# this actually does the 'composer install'
composer require drush/drush:~8.1 burdamagazinorg/image-derive-all:master@dev

# Move theme to destination
rm -rf ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin
mv ${HOME}/build/BurdaMagazinOrg/theme-thunder-admin ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

cd ${HOME}/build/test-dir/docroot/themes/contrib/thunder_admin

# Pull images (and add gitattributes otherwise images show up as modified)
echo "screenshots/reference/** filter=lfs diff=lfs merge=lfs -text" > .gitattributes
git-lfs pull

cd ${HOME}/build/test-dir/docroot

# Install thunder
# /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`"
${HOME}/build/test-dir/bin/drush site-install thunder --account-pass=admin --db-url=mysql://thunder:thunder@127.0.0.1/drupal install_configure_form.enable_update_status_module=NULL -y
