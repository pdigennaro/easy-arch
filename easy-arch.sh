#!/bin/sh
echo "
 _______  _______  _______             _______  _______  _______
(  ____ \(  ___  )(  ____ \|\     /|  (  ___  )(  ____ )(  ____ \\\

| (    \/| (   ) || (    \/( \   / )  | (   ) || (    )|| (    \/
| (__    | (___) || (_____  \ (_) /   | (___) || (____)|| |      
|  __)   |  ___  |(_____  )  \   /    |  ___  ||     __)| |      
| (      | (   ) |      ) |   ) (     | (   ) || (\ (   | |      
| (____/\| )   ( |/\____) |   | |     | )   ( || ) \ \__| (____/\\\

(_______/|/     \|\_______)   \_/     |/     \||/   \__/(_______/
"

VER=0.1a
echo "Easy Arc script v. $VER"

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
fi

BLUETOOTH=false
NVIDIA=false

if [ "$#" -gt 2 ]; then
    echo "Illegal number of parameters"
    exit -1
else 	
	for var in "$@"
		do
			#echo "$var"
			
			if [ "$var" == "--bluetooth" ]; then
				echo "Bluetooth enabled!" 
				BLUETOOTH=true
			fi
			
			if [ "$var" == "--nvidia" ]; then
				echo "Nvidia enabled!"
				NVIDIA=true
			fi
		done

fi

echo Insert your name, please
read current_name

echo Insert your email, please
read email

sudo pacman -S --needed zim libreoffice-fresh r rhythmbox filezilla uget qbittorrent vlc geany p7zip gimp cheese exfat-utils fuse-exfat gparted conky plank qtox xclip python-pip tk tilix meld redshift vulkan-tools cmake ninja clang blender godot mariadb nginx xorg xfce4 xfce4-goodies file-roller leafpad galculator lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings capitaine-cursors arc-gtk-theme xdg-user-dirs-gtk devtools git jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc jre17-openjdk-headless jre17-openjdk jdk17-openjdk openjdk17-doc texstudio texmaker texlive-most ntp ufw wget alacarte cups cups-pdf simple-scan alsa-utils pulseaudio pavucontrol pulseaudio-alsa usbutils simple-scan cups cups-pdf docker xfce4-whiskermenu-plugin thunderbird papirus-icon-theme gvfs nfts-3g firefox chromium

sudo usermod -aG docker ${USER}

sudo systemctl start pulseaudio

sudo systemctl start cups.service
sudo systemctl enable cups.service

sudo timedatectl set-timezone Europe/Rome
sudo timedatectl set-ntp true
sudo systemctl start ntpd && sudo systemctl enable ntpd
sudo ntpq -p

sudo pacman -S ufw
sudo ufw enable

sudo systemctl enable cups.service

pip install rangehttpserver

if "$NVIDIA"; then
	sudo pacman -S nvidia lib32-nvidia-utils nvidia-settings
fi 

if "$BLUETOOTH"; then
	echo "Enable bluetooth audio!"
	sudo pacman -S bluez bluez-utils blueman pulseaudio-bluetooth
	sudo systemctl enable bluetooth.service
	sudo systemctl start bluetooth.service
fi

git config --global core.editor "vim"
git config --global user.email "$current_name"
git config --global user.name "$email"

sudo archlinux-java set java-17-openjdk

wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
sudo chmod +x ./dotnet-install.sh 
./dotnet-install.sh --version latest
./dotnet-install.sh --channel 7.0

ssh-keygen -t ed25519 -C "$email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
