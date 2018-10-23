#!/bin/bash -ex

### Rebuild caches and start servers

cd ${HOME}/build/test-dir/docroot

# Install styleguide
drush -y en thunder_styleguide

# Final cache rebuild, to make sure every code change is respected
drush cr

# Pre-create all image styles for entity browser.´
drush image-derive-all

# Run the webserver
drush runserver --default-server=builtin 0.0.0.0:8080 &>/dev/null &

# Run Selenium2 server with Browser relevant for running environment
if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    # Pin chrome 68 (due to viewport resize bug).
    docker run -d -p 4444:4444 --shm-size 256m --net=host selenium/standalone-chrome:3.14.0-curium
elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    # Use firefox 60 (where esr branches off).
    docker run -d -p 4444:4444 --shm-size 256m --net=host selenium/standalone-firefox:3.12.0-cobalt
fi

# Show dockers
docker ps -a
