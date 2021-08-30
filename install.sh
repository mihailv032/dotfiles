#!/bin/bash


ussage() {
  echo 'Ussage'
  echo 's system packages'
  echo 'f full package install'
  echo 'b base package install' 
  echo 'c install all the config files'
  echo 'w wine dependencies'
}

system() {
  sudo pacman -S sudo grub grub-btrfs efibootmgr dosfstools os-prober ntfs-3g mtools networkmanager \
  base-devel intel-ucode nvidia lib32-nvidia-utils nvidia-utils mesa mesa-demos xorg xmlto kmod \
  dkms inetutils bc libelf cpio perl tar xz
}

full() {
  system
  sudo pacman -S i3blocks imagemagick xorg-xrandr xorg-font soundux deluge deluge-gtk \
  steam ttf-liberation gcolor2 picom code lutris wine-staging winetricks sddm xmonad qtile openbox i3-wm \
  rofi audacity figma-linux gimp gnome-system-monitor android-file-transfer nitrogen neofetch \
  node npm
  basePkg
  wine
  aur 
}

basePkg() {
  sudo pacman -S git alacritty xterm htop moc ranger thunar feh emacs vim flameshot \
  ruby rust eom vlc pavucontrol lxappearance xfce4-settings chromium qutebrowser firefox \
  discord
  yay
  cargo install bat 
  gem install colorls
}

yay() {
  cd /tmp
  git clone https://aur.archlinux.org/yay.git && cd yay	
  makepkg -si
}

aur() {
  yay -S scrot siji-git ttf-font-awesome polybar luent-reader
}

wine() {
  sudo pacman -S giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox 
}

vm() {
  sudo pacman -S qemu qemu-arch-extra ovmf edk2-armvirt gnome-boxes virt-manager ebtables dnsmasq \
  virtualbox  virtualbox-host-modules-arch 
  modprobe vboxdrv
#  systemd-modules-load.service virtualbox-host-modules-arch
# sudo usermod -a -G kvm USR
# sudo suermod -a -G libvirt USR
# systemctl enable libvirtd
# systemctl start libvirtd
}

config() {
  cd /tmp
  git clone git@github.com:mishgun032/i3-config.git
  cd i3-config
  local config=$HOME/.config
  local i3=$config/i3
  local polybar=$config/polybar
  local picom=$config/picom 
  local neofetch=$config/neofetch
  local rofi=$config/rofi
  local gamelauncher=rofi/gamelauncher
  local powermenu=rofi/powermenu
  local moc=$HOME/.moc

  mkdir -p $config/{i3,polybar,picom}
  mkdir -p $config/{rofi}/{gameLauncher,powermenu}
  cp -r i3 $i3
  cp -r polybar $polybar
  cp -r rofi $rofi
  cp -r neofetch $neofetch
  cp -r .moc $moc
  cp Xsetup /usr/share/sddm/scripts/Xsetup
}

case "$1" in 
	s) system ;;
	f) full ;;
	b) basePkg ;;
	c) config ;;
	w) wine ;;
	*) ussage 
esac	


