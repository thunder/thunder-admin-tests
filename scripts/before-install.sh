#!/bin/bash -ex

# Disable xdebug.
echo "" > ~/.phpenv/versions/$(phpenv version-name)/etc/conf.d/xdebug.ini

# Stop drush from sending email
echo "sendmail_path = /bin/true" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

phpenv rehash

# Show php modules
php -m

# Use node 12
nvm install 12
nvm use 12
