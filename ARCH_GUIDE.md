500 MiB, fat32, /boot/efi, boot flag

# Arch Linux 

localectl list-keymaps

loadkeys it

ip a # to check connectivity

ip link

## to connect to a WIFI network
iwctl

device list

station device scan

station device get-networks

station device connect SSID

FIXIA

If device or station powered off try:

device or adapter <dev|ada> set-property Powered on;

or

rfkill unblock all

## create partitions
fdisk -l

or: lsblk

cfdisk /dev/sda

## format
mkfs.ext4 /dev/sda1

mkfs.ext4 /dev/sda2

INFO: when formatting pre-existing ext4 partitions, use this:

mkfs.ext4 -E lazy_itable_init=0 /dev/...

otherwise on the very first startup the ext4lazyinit will take a lot of time...

https://superuser.com/questions/1584873/will-long-time-ext4lazyinit-damage-the-drive-why-initializing-inode-tables-in-e

mkswap /dev/sda3

swapon /dev/sda3

### for the efi partition:
(after creating a 500M partition)

mkfs.fat -F32 /dev/sda1

## ROOT PARTITION
mount /dev/root_partition /mnt

## SEPARATE HOME
mkdir /mnt/home

mount /dev/sda3 /mnt/home

## EFI
mkdir -p /mnt/boot/EFI

mount /dev/sda1 /mnt/boot/EFI

pacstrap -K /mnt base linux linux-firmware base-devel vim nano dhcpcd net-tools grub networkmanager network-manager-applet wireless_tools wpa_supplicant ntfs-3g os-prober efibootmgr dialog mtools dosfstools linux-headers

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

hwclock --systohc

### locales
Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8 and other needed UTF-8 locales. Generate the locales by running: 
locale-gen

vim /etc/locale.conf
LANG=it_IT.UTF-8

vim /etc/vconsole.conf
KEYMAP=it

vim /etc/hostname

vim /etc/hosts
127.0.0.1 localhost
::1 localhost
127.0.1.1 archvb.localdomain archvb

# password for root user
passwd

## NO SWAP PARTITION
fallocate -l 2GB /swapfile

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

add to /etc/fstab
/swapfile none swap 0 0 

grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB

vim /etc/default/grub
and uncomment: GRUB_DISABLE_OS_PROBER=false

grub-mkconfig -o /boot/grub/grub.cfg

## final steps
exit

umount -a

reboot

## after rebooting

systemctl start NetworkManager

systemctl enable NetworkManager

## to connect
nmtui
(then activate connection, etc...)

## add new user
useradd -m -G wheel pietro
passwd pietro

vim /etc/sudoers
add: pietro ALL=(ALL) ALL
