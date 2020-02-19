#!/bin/bash -ex

if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    # Pin chrome.
    sudo apt-get install google-chrome-stable chromedriver

elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    # Use firefox 68 (nearest to Firefox Quatum 68 ESR).
    sudo add-apt-repository ppa:mozillateam/ppa
    sudo apt-get update
    sudo apt-get install firefox-esr xvfb firefox-geckodriver mesa-utils libgl1-mesa-glx
fi
