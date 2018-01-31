#!/usr/bin/env bash

# add recent nodejs
source ~/.nvm/nvm.sh
nvm install stable -q

# remove xdebug to make php execute faster
phpenv config-rm xdebug.ini


# show php modules
php -m


# Prepare MySQL user and database
mysql -e "CREATE DATABASE drupal;"
mysql -e "CREATE USER 'thunder'@'localhost' IDENTIFIED BY 'thunder';"
mysql -e "GRANT ALL ON drupal.* TO 'thunder'@'localhost';"
