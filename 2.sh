#!/bin/bash
safe_apt_install "sudo apt-get -y update" 5
sleep 0.5
safe_apt_install "sudo -E apt-get -y --allow-downgrades  install /opt/nvidia/deb_repos/deepstream-6.3_6.3.0-1_arm64.deb" 5
sleep 5
sudo rm -f /opt/nvidia/deb_repos/deepstream-6.3_6.3.0-1_arm64.deb
