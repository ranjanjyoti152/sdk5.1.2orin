#!/bin/bash
set -e
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

exec 3>&1
exec 1>&2
exec 2>&3
function safe_apt_install {
    echo "*begin $1, $2"
    tmp_log=/tmp/sdkm_apt_install_log.txt
    sudo rm -f $tmp_log
    set +e; $1 2>$tmp_log; CMD_STATUS=${PIPESTATUS[0]}; set -e
    MAX_RETRY=3
    TIMES=1
    while [ ${CMD_STATUS} -ne 0 ]; do
        cat $tmp_log > /dev/stderr
        if grep -q -e "is locked by another process" -e "E: Could not get lock /var/" -e "Could not open lock" $tmp_log; then
           sudo rm -f $tmp_log
           set +e; $1 2>$tmp_log; CMD_STATUS=${PIPESTATUS[0]}; set -e
           echo "Waiting $2 seconds for apt to be available"; sleep ${2}
        elif [ $TIMES -lt $MAX_RETRY ]; then
           echo "safe apt install failed: $1, exit code: $CMD_STATUS, retry number: $TIMES"
           echo "will sleep $[ $TIMES*10 ] seconds before next attempt"
           sleep $[ $TIMES*10 ]
           TIMES=$[ $TIMES + 1 ]
           sudo rm -f $tmp_log
           set +e; $1 2>$tmp_log; CMD_STATUS=${PIPESTATUS[0]}; set -e
        else
           echo "Unhandled error when running $1: `tr '\n' '; ' <$tmp_log`" 1>&2; exit 1
        fi
    done
    if [ $CMD_STATUS -eq 0 ] && [ $TIMES -ne 1 ]; then
        echo "safe apt install succeed. retry number: $TIMES."
    fi
}
safe_apt_install "sudo apt-get -y update" 5
sleep 0.5
safe_apt_install "sudo -E apt-get -y --allow-downgrades  install /opt/nvidia/deb_repos/nv-tensorrt-local-repo-l4t-8.5.2-cuda-11.4_1.0-1_arm64.deb" 5
sleep 5
# ensure package version from local repository has a higher priority
sudo mkdir -p /etc/apt/preferences.d/
sudo rm -f /etc/apt/preferences.d/sdkm
sudo touch /etc/apt/preferences.d/sdkm
echo 'Package: *' | sudo tee -a /etc/apt/preferences.d/sdkm
echo 'Pin: origin ""' | sudo tee -a /etc/apt/preferences.d/sdkm
echo 'Pin-Priority: 999' | sudo tee -a /etc/apt/preferences.d/sdkm

packageName=$(dpkg -f /opt/nvidia/deb_repos/nv-tensorrt-local-repo-l4t-8.5.2-cuda-11.4_1.0-1_arm64.deb Package)
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

safe_apt_install "sudo -E apt-get -y  install tensorrt-libs " 5
targetDebRepoPackageName=$(dpkg -f /opt/nvidia/deb_repos/nv-tensorrt-local-repo-l4t-8.5.2-cuda-11.4_1.0-1_arm64.deb Package | tr -d '\n')
echo targetDebRepoPackageName $targetDebRepoPackageName
if [ -n "targetDebRepoPackageName" ]
then
    safe_apt_install "sudo apt-get purge -y $targetDebRepoPackageName" 5
else
    echo 'Warning: target deb repo package name not found' >&2
fi
sudo rm -f /etc/apt/preferences.d/sdkm

sudo rm -f /opt/nvidia/deb_repos/nv-tensorrt-local-repo-l4t-8.5.2-cuda-11.4_1.0-1_arm64.deb
