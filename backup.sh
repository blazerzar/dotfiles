#!/bin/bash

cp /etc/X11/xorg.conf.d/60-nvidia-monitors.conf nvidia/.
cp /etc/X11/xorg.conf.d/50-mouse-acceleration.conf mouse/.

cp ~/.config/mimeapps.list mimeapps/.

cp ~/.config/fontconfig/fonts.conf fonts/.

cp /etc/tmpfiles.d/disable-usb-wake.conf suspend/.

cp ~/.config/picom/picom.conf picom/.

# Polybar
cp ~/.config/polybar/config.ini polybar/.
cp ~/.config/polybar/launch.sh polybar/.

cp ~/.stalonetrayrc stalonetray/.

# Rofi
cp ~/.config/rofi/dmenu.rasi rofi/.
cp ~/.config/rofi/windows_menu.rasi rofi/.
cp ~/.config/rofi/power_menu.rasi rofi/.
cp ~/.config/rofi/power_profile.rasi rofi/.

# i3
cp ~/.config/i3/config i3/.
cp ~/.config/i3/user_scripts/. i3/scripts -rf

# zsh
cp ~/.zshenv zsh/.
cp ~/.zshrc zsh/.

# ssh (for git)
cp ~/.ssh/config ssh/.

# Simple vim config for indentations
cp ~/.vimrc vim/.

# kitty
cp ~/.config/kitty/. kitty -rf

# Keyboard layout change
cp /etc/X11/xorg.conf.d/00-keyboard.conf keyboard/.
