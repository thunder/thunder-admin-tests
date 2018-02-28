#!/usr/bin/env bash

# Create thunder project
composer create-project burdamagazinorg/thunder-project:2.x ${THUNDER} --stability dev --no-interaction --no-install

cd ${THUNDER}

# Drush 8 is needed as long as there is no drush 9 command version for image-derive-all
# this actually does the 'composer install'
composer require drush/drush:~8.1 burdamagazinorg/image-derive-all:master@dev

# Checkout theme
if [ ! -d "$HOME/builds/BurdaMagazinOrg/theme-thunder-admin" ]; then
    mkdir ~/builds/BurdaMagazinOrg
    cd  ~/builds/BurdaMagazinOrg
    git clone --depth=50 https://github.com/BurdaMagazinOrg/theme-thunder-admin.git -b 8.x-2.x
fi

# Move theme to destination
rm -rf ${THEME}
mv ~/builds/BurdaMagazinOrg/theme-thunder-admin ${THEME}

cd ${THEME}

# Pull images (and add gitattributes otherwise images show up as modified)
echo "screenshots/reference/** filter=lfs diff=lfs merge=lfs -text" > .gitattributes
git-lfs pull

cd ${THUNDER}/docroot

# Install thunder
# /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`"
${THUNDER}/bin/drush site-install thunder --account-pass=admin --db-url=mysql://thunder:thunder@127.0.0.1/drupal install_configure_form.enable_update_status_module=NULL -y
