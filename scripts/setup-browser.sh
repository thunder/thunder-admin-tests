#!/bin/bash -ex

if [[ ${SHARPEYE_BROWSER} == "chrome" ]]; then
    # Pin chrome.
    docker run -d -p 4444:4444 --shm-size 2g --net=host selenium/standalone-chrome:3.141.59-zinc
elif [[ ${SHARPEYE_BROWSER} == "firefox" ]]; then
    # Use firefox 68 (nearest to Firefox Quantum 68 ESR).
    docker run -d -p 4444:4444 --shm-size 2g --net=host selenium/standalone-firefox:3.141.59-titanium
fi
