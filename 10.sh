#!/bin/bash

safe_apt_install "sudo apt-get -y update" 5
sleep 0.5
safe_apt_install "sudo -E apt-get -y --allow-downgrades  install /opt/nvidia/deb_repos/nvidia-l4t-jetson-multimedia-api_35.4.1-20230801124926_arm64.deb" 5
sleep 5
sudo rm -f /opt/nvidia/deb_repos/nvidia-l4t-jetson-multimedia-api_35.4.1-20230801124926_arm64.deb
