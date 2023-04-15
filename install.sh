#!/bin/bash

sudo cp nvidia/60-nvidia-monitors.conf /etc/X11/xorg.conf.d/.
sudo cp mouse/50-mouse-acceleration.conf /etc/X11/xorg.conf.d/.

cp mimeapps/mimeapps.list ~/.config/.

cp fonts/fonts.conf ~/.config/fontconfig/.

sudo cp suspend/disable-usb-wake.conf /etc/tmpfiles.d/.

cp picom/picom.conf ~/.config/picom/.

# Polybar
cp polybar/config.ini ~/.config/polybar/.
cp polybar/launch.sh ~/.config/polybar/.
chmod +x ~/.config/polybar/launch.sh

cp stalonetray/.stalonetrayrc ~/.

# Rofi
cp rofi/dmenu.rasi ~/.config/rofi/.
cp rofi/windows_menu.rasi ~/.config/rofi/.
cp rofi/power_menu.rasi ~/.config/rofi/.
cp rofi/power_profile.rasi ~/.config/rofi/.

# i3
cp i3/config ~/.config/i3/.
cp i3/scripts/. ~/.config/i3/user_scripts -rf

# zsh
cp zsh/.zshenv ~/.
cp zsh/.zshrc ~/.

# ssh (for git)
cp ssh/config ~/.ssh/.

# Simple vim config for indentaions
cp vim/.vimrc ~/.

# kitty
cp kitty/. ~/.config/kitty -rf
