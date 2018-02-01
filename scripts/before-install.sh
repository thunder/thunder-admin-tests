#!/usr/bin/env bash

# Add recent nodejs
##source ~/.nvm/nvm.sh 2> /dev/null
##nvm install stable 2> /dev/null

# Remove xdebug to make php execute faster
phpenv config-rm xdebug.ini

# Show php modules
php -m

# Prepare MySQL user and database
mysql -e "CREATE DATABASE drupal;"
mysql -e "CREATE USER 'thunder'@'localhost' IDENTIFIED BY 'thunder';"
mysql -e "GRANT ALL ON drupal.* TO 'thunder'@'localhost';"
