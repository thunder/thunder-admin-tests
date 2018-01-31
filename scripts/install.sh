#!/usr/bin/env bash

# create thunder project
composer create-project burdamagazinorg/thunder-project:2.x ~/builds/thunder --stability dev --no-interaction --no-install


# Drush 8 is needed as long as there is no drush 9 command version for image-derive-all
composer require drush/drush:~8.1

# setup theme
cd ~/builds
git clone --depth=50 https://github.com/BurdaMagazinOrg/theme-thunder-admin.git -b 8.x-2.x

ls ~/builds/thunder/docroot/themes ~/builds/thunder/docroot/themes/contrib
rm -rf ~/builds/thunder/docroot/themes/contrib/thunder_admin/
ln -s ~/builds/theme-thunder-admin ~/builds/thunder/docroot/themes/contrib/thunder_admin

#drush site-install standard install_configure_form.enable_update_status_module=NULL
# /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`"
drush si thunder --account-pass=admin --db-url=mysql://thunder:thunder@127.0.0.1/drupal install_configure_form.enable_update_status_module=NULL -y
