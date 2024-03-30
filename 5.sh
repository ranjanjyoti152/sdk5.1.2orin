#!/bin/bash
safe_apt_install "sudo apt-get -y update" 5
sleep 0.5
safe_apt_install "sudo -E apt-get -y --allow-downgrades  install /opt/nvidia/deb_repos/cudnn-local-tegra-repo-ubuntu2004-8.6.0.166_1.0-1_arm64.deb" 5
sleep 5
# ensure package version from local repository has a higher priority
sudo mkdir -p /etc/apt/preferences.d/
sudo rm -f /etc/apt/preferences.d/sdkm
sudo touch /etc/apt/preferences.d/sdkm
echo 'Package: *' | sudo tee -a /etc/apt/preferences.d/sdkm
echo 'Pin: origin ""' | sudo tee -a /etc/apt/preferences.d/sdkm
echo 'Pin-Priority: 999' | sudo tee -a /etc/apt/preferences.d/sdkm

packageName=$(dpkg -f /opt/nvidia/deb_repos/cudnn-local-tegra-repo-ubuntu2004-8.6.0.166_1.0-1_arm64.deb Package)
keyringFilePath=$(dpkg -L $packageName | grep 'keyring\.gpg$' | head -n 1 | tr -d "\n")
if [ -n "$keyringFilePath" ]
then
	if [ -f "$keyringFilePath" ]
	then
		sudo cp $keyringFilePath /usr/share/keyrings/
	else
		echo 'Warning: deb repo keyring file not found' >&2
	fi
else
	pubKeyFilePath=$(dpkg -L $packageName | grep '\.pub$' | head -n 1 | tr -d "\n")
	echo $pubKeyFilePath
	if [ -n "$pubKeyFilePath" ]
	then
		safe_apt_install "sudo apt-key add $pubKeyFilePath" 5
	else
		echo 'Warning: deb repo pub key file not found' >&2
	fi
fi
sleep 2
safe_apt_install "sudo apt-get -y update" 5

safe_apt_install "sudo -E apt-get -y  install libcudnn8 " 5
targetDebRepoPackageName=$(dpkg -f /opt/nvidia/deb_repos/cudnn-local-tegra-repo-ubuntu2004-8.6.0.166_1.0-1_arm64.deb Package | tr -d '\n')
echo targetDebRepoPackageName $targetDebRepoPackageName
if [ -n "targetDebRepoPackageName" ]
then
    safe_apt_install "sudo apt-get purge -y $targetDebRepoPackageName" 5
else
    echo 'Warning: target deb repo package name not found' >&2
fi
sudo rm -f /etc/apt/preferences.d/sdkm

sudo rm -f /opt/nvidia/deb_repos/cudnn-local-tegra-repo-ubuntu2004-8.6.0.166_1.0-1_arm64.deb
