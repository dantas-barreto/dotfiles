# dotfiles

dependencias necessarias:
- xorg
- xorg-init
- i3
- vim
- firefox
- alacritty
- nitrogen
- picom
- yay
- ranger
- thunar
- pavucontrol

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
