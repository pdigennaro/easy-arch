#!/bin/sh

#use https://t.ly/VN1Q
GITHUB_DESKTOP_LINK=https://github.com/shiftkey/desktop/releases/download/release-3.2.7-linux2/GitHubDesktop-linux-x86_64-3.2.7-linux2.AppImage
ANDROID_STUDIO_LINK=https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.3.1.18/android-studio-2022.3.1.18-linux.tar.gz
ECLIPSE_LINK=https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2023-06/R/eclipse-jee-2023-06-R-linux-gtk-x86_64.tar.gz

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

VER=2.0a
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

sudo pacman -S --needed ntp zim libreoffice-fresh r rhythmbox filezilla uget qbittorrent vlc geany p7zip gimp cheese exfat-utils fuse-exfat gparted conky plank qtox xclip libbsd \
							python-pip tk tilix meld redshift vulkan-tools cmake ninja clang blender mariadb nginx xorg xfce4 xfce4-goodies file-roller leafpad galculator lightdm lightdm-gtk-greeter \
							lightdm-gtk-greeter-settings capitaine-cursors arc-gtk-theme xdg-user-dirs-gtk devtools git jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc \
							jre17-openjdk-headless jre17-openjdk jdk17-openjdk openjdk17-doc texstudio texmaker texlive ntp ufw wget alacarte cups cups-pdf simple-scan alsa-utils pulseaudio pavucontrol \
							pulseaudio-alsa usbutils simple-scan cups cups-pdf docker docker-buildx xfce4-whiskermenu-plugin thunderbird papirus-icon-theme gvfs ntfs-3g firefox chromium jq \
							virtualbox audacity godot maxima qt5ct qt6ct noto-fonts cantarell-fonts kvantum engrampa openssl-1.1 cpio flatpak flatpak-builder keepass inetutils dbeaver
	
# for mariadb						
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
							
sudo systemctl enable lightdm
sudo systemctl enable NetworkManager

sudo usermod -aG docker ${USER}

sudo systemctl start pulseaudio

sudo systemctl start cups.service
sudo systemctl enable cups.service

sudo timedatectl set-timezone Europe/Rome
sudo timedatectl set-ntp true
sudo systemctl start ntpd && sudo systemctl enable ntpd
sudo ntpq -p

sudo ufw enable

sudo systemctl enable cups.service

pip install rangehttpserver

if "$NVIDIA"; then
	sudo pacman -S nvidia nvidia-utils nvidia-settings
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

# dotnet
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
sudo chmod +x ./dotnet-install.sh 
./dotnet-install.sh --version latest
./dotnet-install.sh --channel 7.0

# SSH keygen generation
ssh-keygen -t ed25519 -C "$email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

# install flatpaks
flatpak install flathub com.unity.UnityHub
flatpak install flathub com.spotify.Client
flatpak install flathub com.getpostman.Postman
flatpak install flathub com.jetbrains.Rider
flatpak install flathub com.jetbrains.PyCharm-Community
flatpak install flathub com.jetbrains.PyCharm-Professional
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate
flatpak install flathub com.jetbrains.CLion
flatpak install flathub com.jetbrains.WebStorm
flatpak install flathub org.telegram.desktop
flatpak install flathub com.visualstudio.code
flatpak install flathub com.vscodium.codium
flatpak install flathub com.sublimetext.three
flatpak install flathub com.sublimemerge.App
flatpak install flathub com.spotify.Client
flatpak install flathub com.pokemmo.PokeMMO
flatpak install flathub org.godotengine.Godot
flatpak install flathub org.kde.krita
flatpak install flathub com.google.Chrome
flatpak install flathub com.google.EarthPro

# some custom software
cd ~
mkdir bins
cd bins

BINS_FOLDER=$(pwd)

wget $GITHUB_DESKTOP_LINK -O Github_desktop_latest.appimage
chmod +x ./Github_desktop_latest.appimage

cd ~ 
sudo mkdir /opt/android
sudo chown -R $USER /opt/android
mkdir /opt/android/sdks
wget $ANDROID_STUDIO_LINK
tar zxvf android-studio-*.tar.gz
mv ./android-studio /opt/android/studio

wget $ECLIPSE_LINK
tar zxvf eclipse*.tar.gz
sudo mv ./eclipse/ /opt/eclipse

echo "[Desktop Entry]
Name=Android Studio
Exec=/opt/android/studio/bin/studio.sh
Comment=The official IDE for Android
Terminal=false
Icon=/opt/android/studio/bin/studio.png
Type=Application" > Android-studio.desktop

echo "[Desktop Entry]
Name=Eclipse
Exec=/opt/eclipse/eclipse
Comment=The legacy Java IDE
Terminal=false
Icon=/opt/eclipse/icon.xpm
Type=Application" > Eclipse.desktop

echo "[Desktop Entry]
Name=Github desktop
Exec=$BINS_FOLDER/Github_desktop_latest.appimage
Comment=Unoffocial fork for Linux
Terminal=false
Type=Application" > Github-desktop.desktop

# here maybe the folder still doesn't exist!
mkdir -p ~/.local/share/applications/

chmod +x *.desktop
mv *.desktop ~/.local/share/applications/

dotnet tool install --global dotnet-dev-certs
dotnet tool install --global dotnet-watch
dotnet tool install --global dotnet-ef

git clone https://github.com/vinceliuice/Matcha-gtk-theme.git
cd Matcha-gtk-theme/
./install.sh

cd ~

# cool bash + some path exports
echo "
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

source /usr/share/git/completion/git-completion.bash
source /usr/share/git/completion/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

# User specific aliases and functions
# color names for readibility
reset=\$(tput sgr0)
bold=\$(tput bold)
black=\$(tput setaf 0)
red=\$(tput setaf 1)
green=\$(tput setaf 2)
dark_green=\$(tput setaf 76)
yellow=\$(tput setaf 3)
blue=\$(tput setaf 4)
magenta=\$(tput setaf 5)
cyan=\$(tput setaf 6)
white=\$(tput setaf 7)
aqua=\$(tput setaf 51)
user_color=\$dark_green
[ \"\$UID\" -eq 0 ] && { user_color=\$red; }
PS1='\[\$reset\][\[\033[01;34m\]\A\[\$reset\]\[\033[01;32m\] \u@\h{\[\$green\]#\l\[\$user_color\]}\
\[\$white\]:\[\$aqua\]\w\[\$reset\]\[\$white\]\[\033[33m\]\$(declare -F __git_ps1 &>/dev/null && __git_ps1 \"(%s)\")\[\033[00m\]\
]\\\\$\[\$reset\] '

#(master u=), u= is the upstream!

ANDROID_BASE=/opt/android/sdks
ANDROID_PLATFORM_TOOLS=\$ANDROID_BASE/platform-tools
ANDROID_TOOLS=\$ANDROID_BASE/tools
ANDROID_NDK=\$ANDROID_BASE/ndk/25.2.9519653

export DOTNET_ROOT=\$HOME/.dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export MSBuildSDKsPath=\$DOTNET_ROOT/sdk/\$(\${DOTNET_ROOT}/dotnet --version)/Sdks

PATH=\$PATH:\`flutter sdk-path\`:\$ANDROID_TOOLS:\$ANDROID_PLATFORM_TOOLS:\$ANDROID_NDK:\$DOTNET_ROOT
export PATH
" >> ~/.bashrc

sudo sh -c "echo 'QT_QPA_PLATFORMTHEME=qt5ct' >> /etc/environment"
