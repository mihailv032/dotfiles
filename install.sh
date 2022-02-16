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
  pacman -S sudo grub grub-btrfs efibootmgr dosfstools os-prober ntfs-3g mtools networkmanager \
  base-devel intel-ucode nvidia lib32-nvidia-utils nvidia-utils mesa mesa-demos xorg xmlto kmod \
  dkms inetutils bc libelf cpio perl tar xz
}

full() {
  sudo pacman -Syu
  sudo pacman -S i3-gaps imagemagick xorg-xrandr deluge deluge-gtk xorg-xmodmap\
  steam ttf-liberation gcolor2 picom code lutris wine-staging winetricks sddm xmonad qtile openbox i3-wm \
  rofi audacity figma-linux gimp gnome-system-monitor android-file-transfer nitrogen neofetch \
  nodejs node-gyp npm
  basePkg
  wine
  aur 
}

basePkg() {
  sudo pacman -S xmonad alacritty xterm htop ranger thunar tumbler feh emacs gvim flameshot \
  ruby rust eom vlc pavucontrol pulseaudio lxappearance xfce4-settings chromium qutebrowser firefox \
  discord
#  yay
  # cargo install bat 
 # gem install colorls
}

yay() {
  cd /tmp
  git clone https://aur.archlinux.org/yay.git && cd yay	
  makepkg -si
}

aur() {
  yay -S scrot siji-git ttf-font-awesome polybar fluent-reader soundux rar gdu
}

wine() {
  sudo pacman -S giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox 
}

vm() {
  sudo pacman -S qemu qemu-arch-extra ovmf edk2-armvirt gnome-boxes virt-manager ebtables dnsmasq \
  virtualbox  virtualbox-host-modules-arch 
  modprobe vboxdrv
# systemd-modules-load.service virtualbox-host-modules-arch
# sudo usermod -a -G kvm USR
# sudo suermod -a -G libvirt USR
# systemctl enable libvirtd
# systemctl start libvirtd
}

config() {
	cd $(dirname $(realpath $0))
	dir=$(dirname $(realpath $0))
#	ln -sf $dir/.bashrc ~/.bashrc
#	ln -sf $dir/.vimrc ~/.vimrc
#	ln -sf $dir/.bash_prompt ~/.bash_prompt
#	ln -sf $dir/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs
#	ln -sf $dir/config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
#	ln -sf $dir/config/picom/picom.conf ~/.config/picom/picom.conf
#	ln -sf $dir/config/neofetch/config.conf ~/.config/neofetch/config.conf
#	ln -sf $dir/config/rofi/config.rasi ~/.config/rofi/config.rasi
#	ln -sf $dir/config/xmobar/xb0 ~/.config/xmobar/xb0
#	ln -sf $dir/config/xmobar/xmobarrc ~/.config/xmobar/xmobarrc
#	ln -sf $dir/config/xmobar/xb3 ~/.config/xmobar/xb3

	ln -nsf $dir/.xmonad/scr/ ~/.xmonad/scr/
#	ln -nsf $dir/config/colorls ~/.config/colorls
#	ln -nsf $dir/config/polybar ~/.config/polybar
#	ln -nsf $dir/config/ranger ~/.config/ranger
#	ln -nsf $dir/config/xmobar/scr ~/.config/xmobar/scr
#	ln -nsf $dir/config/rofi/powermenu ~/.config/rofi/powermenu
#	ln -nsf $dir/config/rofi/gameLauncher ~/.config/rofi/gameLauncher
#	ln -nsf $dir/config/i3 ~/.config/i3
		
  #setting default file manager 
#  xdg-mime default thunar.desktop inode/directory

  #monitor settings for sddm
#  sudo cp Xsetup /usr/share/sddm/scripts/Xsetup

  #monitor & keyboard settings 
#  sudo cp xorg/* /etc/X11/xorg.conf.d/

  #config files 
#  cp config/* $HOME/.config/

}

case "$1" in 
	s) system ;;
	f) full ;;
	b) basePkg ;;
	c) config ;;
	w) wine ;;
	*) ussage 
esac	


