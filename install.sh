#!/bin/bash
set -e

echo "==> Updating system..."
sudo pacman -Syu --noconfirm

if ! command -v yay &>/dev/null; then
    echo "==> Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

PACMAN_PKGS=(
    bluez bluez-utils blueman zsh foot
    rofi pamixer hypridle hyprlock otf-font-awesome
    swww ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common
    cava fastfetch firefox git kitty swaync waybar
    grim slurp yazi hyprpicker
    thunar neovim unzip zip p7zip unrar
    network-manager-applet xdg-user-dirs xdg-utils
    wl-clipboard socat rsync openssh man-db man-pages python python-pip brightnessctl
)

YAY_PKGS=(
    ttf-jetbrains-mono-nerd
    grimblast-git
    nmgui
    matugen
    neofetch
    wlogout
)

echo "==> Installing pacman packages..."
for pkg in "${PACMAN_PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        sudo pacman -S --noconfirm --needed "$pkg" || echo "⚠️ Skipped $pkg"
    fi
done

echo "==> Installing yay packages..."
for pkg in "${YAY_PKGS[@]}"; do
    if ! yay -Qi "$pkg" &>/dev/null; then
        yay -S --noconfirm --needed "$pkg" || echo "⚠️ Skipped $pkg"
    fi
done

echo "==> Enabling Bluetooth..."
sudo systemctl enable --now bluetooth.service

if [ -d ./config ]; then
    echo "==> Copying dotfiles..."
    mkdir -p ~/.config
    cp -r ./config/* ~/.config/
fi

if [ -d ./Wallpapers ]; then
    echo "==> Copying wallpapers..."
    mkdir -p ~/Pictures
    cp -r ./Wallpapers/* ~/Pictures/
fi

echo "Install Complete"
