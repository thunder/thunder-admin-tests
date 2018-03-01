#!/usr/bin/env bash

### Rebuild caches and start servers

cd ${HOME}/build/test-dir/docroot

# Final cache rebuild, to make sure every code change is respected
drush cr

# Pre-create all image styles for entity browser.´
drush image-derive-all

# Run the webserver
drush runserver --default-server=builtin 0.0.0.0:8080 &>/dev/null &

# Run Selenium2 server with Browser relevant for running environment
if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    docker pull selenium/standalone-chrome:3.4.0-einsteinium
    docker run -d -p 4444:4444 --shm-size 256m --net=host selenium/standalone-chrome:3.4.0-einsteinium
elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    docker pull selenium/standalone-firefox:3.4.0-einsteinium
    docker run -d -p 4444:4444 --shm-size 256m --net=host selenium/standalone-firefox:3.4.0-einsteinium
fi

# Show dockers
docker ps -a