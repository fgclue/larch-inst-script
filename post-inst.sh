echo "post-inst.sh started."
echo "==> Configuring locales..."
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
read -p "What do you want to be the hostname?: " hostnameNew
echo $hostnameNew >> /etc/hostname

# Install Software
echo "==> Installing Software..."
pacman -Sy openssh htop wget iwd wireless_tools networkmanager wpa_supplicant smartmontools xdg-utils -y
echo "=> Installing GNOME & GNOME Software"
pacman -Sy gnome gnome-tweaks gnome-calculator zip tar file-roller gnome-weather gnome-chess gnome-clocks gnome-contacts gnome-caracthers gnome-calendar gnome-connections gnome-system-monitor gnome-photos gnome-software -y
echo "=> Installing KDE & Discover"
pacman -Sy plasma-meta konsole kwrite dolphin ark plasma-wayland-session egl-wayland -y
echo "=> Installing other DEs (hyprland, i3, sway, Weston and Cinnamon)"
pacman -Sy hyprland dunst xdg-desktop-portal-hyprland qt5-wayland qt6-wayland -y
pacman -Sy i3-wm i3lock i3status i3blocks xterm lightdm-gtk-greeter lightdm dmenu rofi -y
pacman -Sy cinnamon system-config-printer gnome-keyring gnome-terminal blueberry metacity -y
pacman -Sy sway swaybg swaylock swayidle waybar dmenu brightnessctl grim slurp pavucontrol foot xorg-xwayland -y
echo "=> DEs and WMs installed. Now installing software."
pacman -Sy nano vi vim xed neovim glade rofi flameshot arduino godot python jre-openjdk jdk-openjdk gnome-boxes firefox nautilus nemo steam aisleriot inkscape krita gimp kdenlive shotcut kitty xterm terminator foot fcft obsidian dmenu rofi flameshot hyprpaper nitrogen keepassxc blender freecad cheese shotwell feh lxappearance discord fish zsh dash bash fontforge gitg htop opendoas sudo scribus mpv obs-studio picom plank thunderbird xorg-xeyes xorg-xcalc networkmanager exa xfburn gnome-builder -y
echo "=> Installing CLI tools..."
pacman -Sy coreutils gcc bat rust ruby zig github-cli git cmake make nodejs neofetch thunar yt-dlp wget -y
# installable true other bash scripts: brew gh-helper jscli bfetch
# Flatpak required: cambalache ImHex corefm anki libreoffice melonDS

echo "=> Configuring Flatpak..."
pacman -Sy flatpak -y
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "=> Installing flatpak packages..."
flatpak install flathub ar.xjuan.Cambalache
flatpak install flathub net.werwolv.ImHex
flatpak install flathub net.ankiweb.Anki
flatpak install flathub org.libreoffice.LibreOffice
flatpak install flathub net.kuribo64.melonDS

echo "=> Installing manually installed packages (brew, bfetch, jscli and gh-helper)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
curl https://raw.githubusercontent.com/fgclue/bfetch/master/more/bfetch-arch > /usr/bin/bfetch
curl https://raw.githubusercontent.com/fgclue/jscli/master/js.rs > js.rs
rustc js.rs -o js
mv js /usr/bin/jsWhen 
rm js.rs

passwd

cat /root/.bash_profile >> /root/.bash_profile.bkp
echo "/first-boot.sh" >> /root/.bash_profile

echo "=> Cloning git repo for configs..."
cd /root
git clone https://github.com/fgclue/dotfiles

mkinitcpio -P
echo "=> Post-Install finished. Rebooting"
exit
umount -R /mnt
echo "==> Please remove the installation media and press ENTER."
read
reboot
