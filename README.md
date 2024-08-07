# dotfiles

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

add:
```
exec startx
```
to .bash_profile

add:
```
nitrogen --restore &  
picom -CGb &  
exec i3  
```
to .xinitrc

add fonts to:
```
~/.local/share/fonts
```
