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

adicione:
```
exec startx
```
em .bash_profile

se dwm:
```
exec dwm
```
em .xinitrc

se i3:
```
nitrogen --restore &  
picom -CGb &  
exec i3  
```
em .xinitrc

adicione suas fontes em:
```
~/.local/share/fonts
```
