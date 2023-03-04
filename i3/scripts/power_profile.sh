#!/usr/bin/bash

##################################
# Power profile selection script #
##################################

# Rofi theme for power profile selection
ROFI_OPTIONS=(-theme ~/.config/rofi/power_profile.rasi)

# Check whether a command exists
function command_exists() {
    command -v "$1" &> /dev/null 2>&1
}

# Check requirements
if ! command_exists powerprofilesctl ; then
    exit 1
fi

# Get current active profile
current_profile=$(powerprofilesctl get)
case $current_profile in
    performance)
        selected_row=0
        ;;
    balanced)
        selected_row=1
        ;;
    power-saver)
        selected_row=2
        ;;
esac
echo $current_profile $selected_row

# Menu options and their commands
declare -A commands
declare -a options

LOCK_CMD="~/.config/i3/scripts/blur-lock"

# Menu with keys/commands
commands[" Performance"]="powerprofilesctl set performance";   options+=( " Performance" )
commands[" Balanced"]="powerprofilesctl set balanced";         options+=( " Balanced" )
commands[" Power Saver"]="powerprofilesctl set power-saver";   options+=( " Power Saver" )

menu_nrows=${#menu[@]}

launcher_exe="rofi"
launcher_options=(
    -dmenu -i -lines "${menu_nrows}" "${ROFI_OPTIONS[@]}" 
    -selected-row $selected_row
)

# Check if rofi is available
if [[ -z "${launcher_exe}" ]]; then
    exit 1
fi

launcher=(${launcher_exe} "${launcher_options[@]}")
selection=$(printf '%s\n' "${options[@]}" | "${launcher[@]}")

if [[ -z $selection ]]; then
    exit 1
fi

i3-msg -q "exec --no-startup-id ${commands[$selection]}"

exit 0

