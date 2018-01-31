#!/usr/bin/env bash

## Setup environment
export THUNDER=`echo ${TRAVIS_BUILD_DIR}"/../thunder"`
export THEME=`echo ${THUNDER}"/docroot/themes/contrib/thunder_admin/"`
export PATH="$THUNDER/bin:$PATH"
