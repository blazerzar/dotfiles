# Linux setup

## System information

- Distribution: [EndeavourOS](https://endeavouros.com/)
- Window manager: [i3](https://i3wm.org/)

## Customizations

### Updates

Update mirrors and all packages on the system.

```bash
sudo reflector \
    --save /etc/pacman.d/mirrorlist \
    --country Slovenia,Austria,Germany,Italy \
    --protocol https \
    --latest 10 \
    --completion-percent 100 \
    --sort rate
sudo eos-rankmirrors
sudo pacman -Syyu
```

Also check `Package cleanup configuration` and
`Configure eos-update-notifier` in the `Welcome` app.

### Installs

```bash
sudo pacman -S vim gnome-keyring nvidia-settings bluez bluez-utils blueman \
    nitrogen ttf-fira-code noto-fonts-emoji flameshot gparted polybar \
    ttf-font-awesome stalonetray zsh kitty spotify-launcher
yay -S visual-studio-code-bin gwe snapd google-chrome discord picom \
    ttf-material-icons-git
```

### Grub

Settings can be changed in `/etc/default/grub`.

```bash
GRUB_DEFAULT='4'
GRUB_CMDLINE_LINUX_DEFAULT='... quiet splash ibt=off'
GRUB_DISABLE_SUBMENU='true'
```

If Grub does not include Windows partition, it needs to be added by OS probing.

```bash
sudo pacman -S os-prober    # Installed in latest version
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Automatically mount data drive

Get drive UUID from `sudo blkid`. Then append one line to `/etc/fstab/`.
Make sure to first create the mount directory, mount the drive and
change its owner.

```bash
sudo mkdir /data
sudo mount /dev/sdb1 /data
sudo chown -R user:user /data
echo "UUID=uuid /data          ext4    defaults   0 2" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
```

### Visual Studio Code

It can be installed from AUR. Keyring needs to be installed to allow log in.

```bash
sudo pacman -S gnome-keyring
yay -S visual-studio-code-bin
```

### Dual boot time fix

Linux needs to be setup to use local time.

```bash
sudo timedatectl set-local-rtc 1
```

### Nvidia

Drivers are installed using `nvidia-inst` (if not installed).

GPU information can be seen using `nvidia-smi`, `inxi -Gx` or in
GreenWithEnvy app.

There might be some problems with HW acceleration. VA-API is not supported
on NVIDIA driver, but can be enabled using `nvidia-vaapi-driver`, adding
the kernel parameter `nvidia-drm.modeset=1` and updating GRUB config file.
If NVIDIA drivers are still not fixed, variable `NVD_BACKEND` needs to be
set to `direct` to use the direct backend. More info can be found on
the Arch Wiki page. I thought this would fix Discord crashes after
resume, but they still persist.

```bash
yay -S gwe
```

Settings (refresh rate and G-Sync) can be set up in Nvidia X Server
Settings app)

```bash
sudo pacman -S nvidia-settings
```

When updating packages using `pacman` and `yay`, Nvidia drivers are updated
as well.

### Bluetooth

Bluetooth needs to be enabled, since it is disabled by default.

```bash
sudo pacman -S bluez bluez-utils
sudo systemctl enable --now bluetooth.service
```

Devices can be connected in the Bluetooth Manager GUI.

```bash
sudo pacman -S blueman
```

To use the keyboard to login, adapter needs to be powered on on boot by
editing `/etc/bluetooth/main.conf`.

```bash
AutoEnable = true # (Spaces around = are important!)
```

This service automatically connects to all paired and trusted bluetooth
devices (not needed in the latest version).

```bash
yay -S bluetooth-autoconnect
sudo systemctl enable bluetooth-autoconnect
systemctl --user enable pulseaudio-bluetooth-autoconnect # Audio devices
```

### Network

NetworkManager Applet is used to configure WiFi.

### Firewall

Enable and start firewall service.

```bash
sudo systemctl enable --now firewalld.service
```

Settings can be changed via `Firewall` app found in the menu.

### Wallpaper

Nitrogen is used to change wallpapers.

```bash
sudo packman -S nitrogen
nitrogen wallpapers_folder # Select wallpapers from wallpapers_folder dir
```

Nitrogen needs to be started in i3 config.

```bash
exec --no-startup-id sleep 2 && nitrogen --restore
```

### Snap

It needs to be installed from AUR and its services need to be enabled.

```bash
yay -S snapd
sudo systemctl enable --now snapd.socket
sudo systemctl enable --now snapd.apparmor
```

### Mouse acceleration

Linux DPI needs to be 2 times Windows DPI. Config file needs to be placed
into `/etc/X11/xorg.conf.d` directory to disable mouse acceleration.

### Google Chrome

It can be installed from AUR.

```bash
yay -S google-chrome
```

To enable middle click scroll, `AutoScroll` extension is installed. To fix
slow Chrome scroll on Linux, `IMWheel` is used (not needed anymore).

```bash
sudo pacman -S imwheel
```

Startup script is then placed in `/etc/profile.d` to autostart the program.

To make Chrome default browser, these files need to be edited:

- `~/.config/i3/config`: Open browser shortcut
- `~/.profile`: BROWSER variable
- `~/.config/mimeapps.list`: Default program per file type

### Speakers not working

If speakers are not working when headphones are plugged in the
front audio jack, Auto-Mut needs to be disabled.

Run `alsamixer`, press `F6` and select audio device, press right
arror to move to `Auto-Mut` and disable it using down arrow.

### Fonts

Fira Code is used in Visual Studio Code and Noto Sans is needed for emojis.

```bash
sudo pacman -S ttf-fira-code noto-fonts-emoji
```

Fonts config file `fonts.conf` needs to be put into `~/.config/fontconfig`
directory.

### Instantaneous wake up from suspend

It is caused by the wireless mouse receiver, even if the mouse
itself does not move or is turned off. File `disable-usb-wake.conf` needs
to be placed in `/etc/tmpfiles.d` directory to disable it.

Working of this fix can be checked using

```bash
cat /proc/acpi/wakeup
```

### Transparency

Picom needs to be installed and executed from i3 config. To fix tearing,
`Force Full Composition Pipeline` needs to be enabled in Nvidia settings.

```bash
yay -S picom
```

### Polybar

First Polybar is installed using Pacman. Config file `config.ini` and launch
script `launch.sh` are in directory `~/.config/polybar` and script needs to
be executable.

```bash
sudo pacman -S polybar
chmod +x ~/.config/polybar/launch.sh
```

Launch script is executed on i3 load and reload.

```bash
exec_always --no-startup-id $HOME/.config/polybar/launch.sh
```

For icons, Font Awesome and Material Icons are used.

```bash
sudo pacman -S ttf-font-awesome
yay -S ttf-material-icons-git
```

### Git

Create SSH key and add it to the agent.

```bash
ssh-keygen -t ed25519 -C "name@email.com"
eval "$(ssh-agent -s)"
ssd-add ~/.ssh/key_file_name
```

Configure Git settings.

```bash
git config --global user.name "First Last"
git config --global user.email "name@email.com"
git config --global init.defaultBranch main
```

To use Vim as editor, variable `EDITOR` needs to be set in file
`~/.profile`.

### Zsh

First Zsh shell needs to be installed and set as default shell.

```bash
sudo pacman -S zsh
chsh -s /bin/zsh
```

After that Oh My Zsh can be installed.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Plugins are downloaded from GitHub and enabled in the `.zshrc` file.

```bash
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
```

Terminal theme can be installed using Gogh (or script `install_theme.sh`).
Font size is increased to size 12.

```bash
bash -c "$(wget -qO- https://git.io/vQgMr)"
```

## Scripts

All dotfiles can be installed using `install.sh` or saved from the system
using `backup.sh`.
