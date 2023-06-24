#!/bin/bash

# -====================-
#  larch install script
# -====================-

clear
echo "-====================-"
echo " larch install script "
echo "-====================-"

echo "--> LArch only supports UEFI. Make sure you are using UEFI."

echo ":: Checking for root/sudo..."
if [[ $EUID = "0" ]]
then
	echo "Running under root user."
else
	echo "Root privilages not found. Try running as root."
	echo "($EUID inst 0)"
	exit
fi

echo ":: Testing Internet..."

# Internet Test:
internetTest=$(ping google.com -c 3 | grep "packet loss" | wc -m)

if [[ $internetTest = "1" ]]
then
	echo "Connection test failed. Exiting with error 1."
	exit
else
	echo "Connection test completed."
fi

curl https://raw.githubusercontent.com/fgclue/larch-inst-script/master/overview.txt > overview.txt
curl https://raw.githubusercontent.com/fgclue/larch-inst-script/master/first-boot.sh > first-boot.sh
curl https://raw.githubusercontent.com/fgclue/larch-inst-script/master/post-inst.sh > post-inst.sh

cat overview.txt | less

# Read input:
read -p "Continue? [DANGEROUS] (y/n): " installConfirmation

if [[ $installConfirmation =~ [y] ]]
then
	echo "--- Starting Installation! Thank you for using the LArch installer."
else
	exit
fi

echo "==> Installing main system"
loadkeys br-abnt2

timedatectl set-timezone America/Sao_Paulo

echo "--> Which disk do you want to install linux in? (example: /dev/sda)"
lsblk
read -p "-> " installDisk
echo "Now, remember the disk partitions:"
echo "${installDisk}1 - EFI System - 1GB"
echo "${installDisk}2 - Linux Swap - 8GB"
echo "${installDisk}3 - Linux Root (x86_64) - Rest of the disk"
read -p "Press any key to continue."
cfdisk $installDisk
mkfs.btrfs ${installDisk}3
mkswap ${installDisk}2
mkfs.fat -F 32 ${installDisk}1

echo "==> Mounting drives..."
mount ${installDisk}3 /mnt
mount --mkdir ${installDisk}1 /mnt/boot
swapon ${installDisk}2

echo "==> Installing Linux & System Applications"
pacstrap -K /mnt base linux linux-firmware sddm gdm vi vim nano sudo opendoas

echo "==> Creating fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "==> Running Post-Install Scripts..."
echo "==> Copying scripts..."
cp first-boot.sh /mnt/first-boot.sh
cp post-inst.sh /mnt/first-boot.sh
chmod +x /mnt/first-boot.sh
chmod +x /mnt/post-inst.sh
arch-chroot /mnt /post-inst.sh
