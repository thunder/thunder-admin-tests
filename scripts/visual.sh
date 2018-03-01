#!/usr/bin/env bash

cd ${HOME}/builds/thunder/docroot/themes/contrib/thunder_admin

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}

