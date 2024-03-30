#!/bin/bash
set -e
exec 3>&1
exec 1>&2
exec 2>&3

function safe_apt_install {
    echo "*begin $1, $2"
    tmp_log=/tmp/sdkm_apt_install_log.proxpc.txt
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
           echo "Error: safe apt install failed: $1, exit code: $CMD_STATUS, retry number: $TIMES"
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
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
safe_apt_install "sudo apt-get install -y gnupg libgomp1 libfreeimage-dev libopenmpi-dev openmpi-bin" 5
grep -q 'export PATH=.*/usr/local/cuda-11.4/bin' ~/.bashrc || echo 'export PATH=/usr/local/cuda-11.4/bin:$PATH'>>~/.bashrc
grep -q 'export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64' ~/.bashrc || echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc