# dotfiles

### Opções do archinstall
- Archinstall language: English
- Locales:
  - Keyboard layout: us
  - Locale language: en_US
  - Locale encoding: UTF-8
- Mirrors:
  - Mirror regions: Brazil
- Disk configuration:
  - Configuration type: Best-effort (ext4)
- Disk encryption: none
- Swap: Enabled
- Bootloader: Grub
- Hostname: _nome da máquina_
- Root password: _senha root_
- User account: _seu nome de usuário e senha_
- Profile:
  - Type: Xorg
  - Graphic driver: All open-source
  - Greeter: não é necessário
- Audio: pulseaudio
- Kernel: default
- Network configuration: NetworkManager
- Additional packages: none
- Optional repositories: multilib
- Timezone:
- Automatic time sync: Enabled

---

dependencias necessarias:
- xorg
- xorg-xinit
- i3
- dmenu (suckless.org)
- neovim
- firefox
- alacritty
- nitrogen
- picom
- yay
- ranger
- thunar
- pavucontrol
- feh
- imagemagick
- brightnessctl
- webkit2gtk
- gcr

adicionar:
```
exec startx
```
em .bash_profile

a configuração padrão é dwm: 
```
# dwm configuration
while true; do
    # Time & Date
    DATE=$(date '+%d/%m/%Y %H:%M:%S')

    # Memory
    MEM=$(free -h | awk '/^Mem/ { print $3"/"$2 }')

    # CPU
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{ print $2 + $4 }' | awk '{ printf "%.2f%%", $1 }')

    # Wi-Fi
    WIFI=$(nmcli -t -f ACTIVE, SSID dev wifi | grep '^yes' | cut -d: -f2)
    if [ -z "$WIFI" ]; then
        WIFI_STATUS="Disconected"
    else
        WIFI_STATUS="$WIFI"
    fi

    # Ethernet
    ETHERNET=$(nmcli -t -f DEVICE, STATE dev | grep ethernet | grep -q connected && echo "Connected" || echo "Disconnected")

    # Disk Usage
    DISK=$(df -h / | awk '/\// { print $3 "/" $2 })

    # Bar
    xsetroot -name " WIFI: $WIFI_STATUS | ETH: $ETHERNET | DISK: $DISK | CPU: $CPU | MEM: $MEM | $DATE "

# i3 configuration
#nitrogen --restore &  
#picom -CGb &  
#exec i3  
```
em .xinitrc

adicione suas fontes em:
```
~/.local/share/fonts
```
