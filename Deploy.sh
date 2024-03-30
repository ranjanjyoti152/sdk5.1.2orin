#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install g++ -y
sudo apt-get install build-essential -y
sudo mount -t cifs //192.168.100.94/proxpc /mnt/NAS -o username=proxpc,password=Tech@77508
echo "Mounting NAS"
cd /mnt/NAS 
cd 'LAB FILES'
rsync -av --progress nvidia ~/
cd
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/2.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/3.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/4.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/5.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/6.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/7.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/8.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/9.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/10.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/11.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/12.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/13.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/14.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/15.sh | sh -
wget -nv -O- https://raw.githubusercontent.com/ranjanjyoti152/sdk5.1.2orin/main/16.sh | sh -
sudo rm -r nvidia 