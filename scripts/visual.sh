#!/usr/bin/env bash

cd ${THEME}

# Run visual regression tests
./node_modules/.bin/sharpeye --single-browser ${SHARPEYE_BROWSER}

