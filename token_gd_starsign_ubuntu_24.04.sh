#!/bin/bash

set -eu

sudo apt update
sudo apt install wget unrar libgdk-pixbuf2.0-0 opensc -y

debian_url="http://ftp.us.debian.org/debian/pool/main"
ubuntu_url="http://security.ubuntu.com/ubuntu/pool/main"
ubuntu_archive_url="http://archive.ubuntu.com/ubuntu/pool/universe"
ubuntu_archive_main_url="http://archive.ubuntu.com/ubuntu/pool/main/o/openssl"

libjpeg62_turbo_="libjpeg62-turbo_2.1.5-3_amd64.deb"
libssl1_1_="libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb"    
libtiff5_="libtiff5_4.1.0+git191117-2ubuntu0.20.04.14_amd64.deb"
libwebp6_="libwebp6_0.6.1-2ubuntu0.20.04.3_amd64.deb"
libwxbase3_0_="libwxbase3.0-0v5_3.0.5.1+dfsg-4_amd64.deb"
libwxgtk3_0_="libwxgtk3.0-gtk3-0v5_3.0.5.1+dfsg-4_amd64.deb"

libjpeg62_turbo="$debian_url/libj/libjpeg-turbo/$libjpeg62_turbo_"
libssl1_1="$ubuntu_archive_main_url/$libssl1_1_"
libtiff5="$ubuntu_url/t/tiff/$libtiff5_"
libwebp6="$ubuntu_url/libw/libwebp/$libwebp6_"
libwxbase3_0="$ubuntu_archive_url/w/wxwidgets3.0/$libwxbase3_0_"
libwxgtk3_0="$ubuntu_archive_url/w/wxwidgets3.0/$libwxgtk3_0_"

safesign_url="https://safesign.gdamericadosul.com.br/content"
safesign_rar="SafeSign_IC_Standard_Linux_3.7.0.0_AET.000_ub2004_x86_64.rar"
safesign_dl="$safesign_url/$safesign_rar"
safesign_deb="SafeSign_IC_Standard_Linux_3.7.0.0_AET.000_ub2004_x86_64.deb"

mkdir -p ~/Downloads/token_gd_starsign
cd ~/Downloads/token_gd_starsign

wget "$libjpeg62_turbo" "$libssl1_1" "$libtiff5" "$libwebp6" "$libwxbase3_0" "$libwxgtk3_0" "$safesign_dl"

sudo dpkg -i ./*.deb || true  # Proceed even if some fail
sudo apt --fix-broken install -y  # Fix missing dependencies

if [ -f "$safesign_rar" ]; then
    unrar x "$safesign_rar"
    rm -f "$safesign_rar"
fi

if [ -f "$safesign_deb" ]; then
    sudo dpkg -i "$safesign_deb"
    sudo apt --fix-broken install -y
fi

sudo systemctl start pcscd.service
sudo systemctl enable pcscd.service

echo "Installation complete. Checking token:"
tokenadmin -l
