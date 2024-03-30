#!/bin/bash
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
safe_apt_install "sudo apt-get install -y gnupg libgomp1 libfreeimage-dev libopenmpi-dev openmpi-bin" 5
grep -q 'export PATH=.*/usr/local/cuda-11.4/bin' ~/.bashrc || echo 'export PATH=/usr/local/cuda-11.4/bin:$PATH'>>~/.bashrc
grep -q 'export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64' ~/.bashrc || echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc