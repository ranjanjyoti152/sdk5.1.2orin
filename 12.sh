#!/bin/bash

safe_apt_install "sudo apt-get -y update" 5
sleep 0.5
safe_apt_install "sudo -E apt-get -y --allow-downgrades  install /opt/nvidia/deb_repos/OpenCV-4.5.4-8-g3e4c170df4-aarch64-samples.deb" 5
sleep 5
sudo rm -f /opt/nvidia/deb_repos/OpenCV-4.5.4-8-g3e4c170df4-aarch64-samples.deb
