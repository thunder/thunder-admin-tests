#!/bin/bash -ex

if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    sudo apt-get update
    sudo apt-get install google-chrome-stable chromium-chromedriver

elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    # Use firefox 68 (nearest to Firefox Quatum 68 ESR).
    sudo add-apt-repository ppa:mozillateam/ppa
    sudo apt-get update
    sudo apt-get install firefox-esr firefox-geckodriver
fi
