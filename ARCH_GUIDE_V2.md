# Arch Linux Installation Guide

## EFI Partition
- **Size:** 500 MiB  
- **Filesystem:** FAT32  
- **Mount point:** `/boot/efi`  
- **Flags:** boot  

---

## Keymap & Network

```bash
localectl list-keymaps
loadkeys it
ip a         # to check connectivity
ip link
```

### Connect to Wi-Fi

```bash
iwctl
device list
station <device> scan
station <device> get-networks
station <device> connect <SSID>
```

#### If device/station is powered off:

```bash
device or adapter <dev|ada> set-property Powered on
# or
rfkill unblock all
```

---

## Create Partitions

```bash
fdisk -l
# or
lsblk
cfdisk /dev/sda
```

---

## Format Partitions

```bash
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2
```

> When formatting pre-existing ext4 partitions:

```bash
mkfs.ext4 -E lazy_itable_init=0 /dev/...
```

Otherwise, on the first boot, lazy init will delay startup significantly.  
[More info](https://superuser.com/questions/1584873/will-long-time-ext4lazyinit-damage-the-drive-why-initializing-inode-tables-in-e)

```bash
mkswap /dev/sda3
swapon /dev/sda3
```

### Format EFI Partition (after creating a 500 MiB partition)

```bash
mkfs.fat -F32 /dev/sda1
```

---

## Mount Partitions

```bash
mount /dev/<root_partition> /mnt

# Separate home
mkdir /mnt/home
mount /dev/sda3 /mnt/home

# EFI
mkdir -p /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI
```

---

## Install Base System

```bash
pacstrap -K /mnt base linux linux-firmware base-devel \
vim nano dhcpcd net-tools grub networkmanager network-manager-applet \
wireless_tools wpa_supplicant ntfs-3g os-prober efibootmgr dialog \
mtools dosfstools linux-headers
```

```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

---

## System Configuration

```bash
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
```

### Locales

Edit `/etc/locale.gen` and uncomment:

```
en_US.UTF-8 UTF-8
it_IT.UTF-8 UTF-8
```

Then:

```bash
locale-gen
```

Create `/etc/locale.conf`:

```bash
LANG=it_IT.UTF-8
```

Create `/etc/vconsole.conf`:

```bash
KEYMAP=it
```

Set hostname:

```bash
vim /etc/hostname
```

Edit `/etc/hosts`:

```
127.0.0.1    localhost
::1          localhost
127.0.1.1    archvb.localdomain archvb
```

Set root password:

```bash
passwd
```

---

## (Alternative) Swap File Instead of Partition

```bash
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

Add to `/etc/fstab`:

```
/swapfile none swap 0 0
```

---

## Install Bootloader

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB

vim /etc/default/grub
# Uncomment:
GRUB_DISABLE_OS_PROBER=false

grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Final Steps

```bash
exit
umount -a
reboot
```

---

## After Reboot

```bash
systemctl start NetworkManager
systemctl enable NetworkManager
```

### Connect to Wi-Fi:

```bash
nmtui
# (Activate connection, etc.)
```

---

## Add New User

```bash
useradd -m -G wheel pietro
passwd pietro
```

Edit `/etc/sudoers` using `visudo`:

```
pietro ALL=(ALL) ALL
```
