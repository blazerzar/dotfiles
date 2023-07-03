#!/usr/bin/bash

#####################
# Power menu script #
#####################

# Rofi theme for power menu
ROFI_OPTIONS=(-theme ~/.config/rofi/power_menu.rasi)

# Check whether a command exists
function command_exists() {
    command -v "$1" &> /dev/null 2>&1
}

# Check requirements
if ! command_exists systemctl ; then
    exit 1
fi

# Menu options and their commands
declare -A commands
declare -a options

LOCK_CMD="~/.config/i3/scripts/blur-lock"

# Menu with keys/commands
commands[10]="systemctl poweroff";                  options+=( " Shutdown (Shift+S)" )
commands[11]="systemctl reboot";                    options+=( " Reboot (R)" )
commands[12]="$LOCK_CMD && systemctl suspend";      options+=( " Suspend (S)" )
commands[13]="systemctl hibernate";                 options+=( " Hibernate (H)" )
commands[14]="xset -display :0.0 dpms force off ";  options+=( "  Monitor off (M)" )
commands[15]="$LOCK_CMD";                           options+=( " Lock (L)" )
commands[16]="i3-msg exit";                         options+=( " Logout (Shift+L)" )

menu_nrows=${#menu[@]}

launcher_exe="rofi"
launcher_options=(
    -dmenu -i -lines "${menu_nrows}" "${ROFI_OPTIONS[@]}"
    -kb-custom-1 "Shift+[39]" # Shift+s
    -kb-custom-2 "r"
    -kb-custom-3 "s"
    -kb-custom-4 "h"
    -kb-custom-5 "m"
    -kb-custom-6 "l"
    -kb-custom-7 "Shift+[46]" # Shift+l
)

# Check if rofi is available
if [[ -z "${launcher_exe}" ]]; then
    exit 1
fi

launcher=(${launcher_exe} "${launcher_options[@]}")
(printf '%s\n' "${options[@]}" | "${launcher[@]}") > /dev/null

# Selected shortcut can be read from the exit code
selection=$?

# Check if shortcut was pressed
if [[ $selection -ge 10 ]] && [[ $selection -le 16 ]]; then
    i3-msg -q "exec --no-startup-id sleep 0.5 && ${commands[$selection]}"
fi

exit 0

