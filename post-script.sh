#!/usr/bin/env bash

if [ $EUID != 0 ]; then
        echo "this script must be run as root"
        echo ""
        echo "usage:"
        echo "sudo "$0
        exit $exit_code
   exit 1
fi


cp sources.list /etc/apt/sources.list
#echo "ops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "ops ALL=(ALL:ALL) ALL" >> /etc/sudoers



apt update -y
apt upgrade -y

apt install task-xfce-desktop -y

curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc| gpg --dearmor -o /etc/apt/trusted.gpg.d/vbox.gpg
curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc| gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg

echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" |  tee /etc/apt/sources.list.d/virtualbox.list

apt update
apt install linux-headers-$(uname -r) dkms -y
apt install virtualbox-7.0 -y

ip l > result.txt
maclist=`grep 'link' result.txt | cut -d " " -f 6`
maceth0=`echo $maclist | cut -d " " -f 2`
maceth1=`echo $maclist | cut -d " " -f 3`

file=10-eth0.link
echo "[Match]" > $file
echo "MACAddress="$maceth0 >> $file
echo " " >> $file
echo "[Link]" >> $file
echo "Name=eth0" >> $file

file=11-eth1.link
echo "[Match]" > $file
echo "MACAddress="$maceth1 >> $file
echo " " >> $file
echo "[Link]" >> $file
echo "Name=eth1" >> $file

echo "copy IFACES files to etc/systemd/network/ and reboot."  

echo "Done."

