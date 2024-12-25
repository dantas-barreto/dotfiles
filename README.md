# dotfiles

Este tutorial descreve como instalar o Arch Linux usando as opções predefinidas do archinstall, bem como as configurações necessárias para configurar um sistema com o gerenciador de janelas `dwm` ou `i3`

## Passo 1: Setup do `archinstall`

Durante a instalação, escolha as seguintes opções no `archinstall`

### Configurações Gerais
- **Archinstall language**: `English`
- **Locales**:
  - **Keyboard layout**: `us`
  - **Locale language**: `en_US`
  - **Locale encoding**: `UTF-8`

### Configurações de Mirror
  - **Mirror regions**: `Brazil`

### Configuração de Disco
- **Configuration type**: Best-effort (`ext4`)
- **Disk encryption**: *Vai de acordo com suas preferências*
- **Swap**: `Enabled`

### Bootloader
- **Bootloader**: `Grub`

### Configuração de Usuário
- **Hostname**: *nome da máquina*
- **Root password**: *senha de administrador*
- **User account**: *seu nome de usuário e senha (ativar opção de sudo)*

### Perfil
  - **Type**: `Xorg`
  - **Graphic driver**: `All open-source`
  - **Greeter**: *não é necessário*

### Configurações de Audio
- **Audio**: `pulseaudio` 

### Kernel
- **Kernel**: `default` 

### Configurações de Rede
- **Network configuration**: `NetworkManager`

### Repositórios Adicionais
- **Optional repositories**: `multilib`

### Configuração de Horário
- **Timezone**: *conforme sua localização*
- **Automatic time sync**: `Enabled`

---

## Passo 2: Instalar Dependências Necessárias
Após concluir a instalação base, reinicie o sistema e instale os seguintes pacotes:
```
sudo pacman -Syu base-devel curl xorg xorg-xinit i3 neovim firefox alacritty nitrogen picom git ranger thunar pavucontrol feh imagemagick brightnessctl webkit2gtk gcr
```

Para instalar o Yay:
```
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

Para instalar o dwm (recomendado instalar junto o dmenu):
```
git clone https://git.suckless.org/dwm
cd dwm
sudo make clean install
```

Para instalar o dmenu:
```
git clone https://git.suckless.org/dmenu
cd dmenu
sudo make clean install
```

## Passo 3: Configurar o `bash_profile`

Adicione o comando para iniciar o ambiente gráfico automaticamente no arquivo `~/.bash_profile`
```
exec startx
```

## Passo 4: Configurar o Ambiente Gráfico

### Configuração Padrão com `dwm`
Crie ou edite o arquivo `~/.xinitrc` com a seguinte configuração:
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
done &
nitrogen --restore &
exec dwm
```

### Configuração alternativa com `i3`
Para usar o `i3`, configure o arquivo `~/.xinitrc` assim:
```
# i3 configuration
nitrogen --restore &  
picom -CGb &  
exec i3  
```

## Passo 5: Configurar o Wallpaper com `nitrogen`
Para definir o Wallpaper com o `nitrogen`, siga os passos abaixo:

1. Abra o `nitrogen`
```
nitrogen
```
2. Navegue até o diretório onde suas imagens de wallpaper estão armazenadas (Há um diretório de Wallpapers neste repositório).
3. Selecione o Wallpaper desejado e clique em **Apply** para aplicá-lo.
 
## Passo 6: Garantir o funcionamento dos Scripts
Certifique-se de que os scripts estejam executáveis. Use o comando:
```
chmod +x nome_do_script.sh
```
Adicione o caminho do script ao `~/.xinitrc` ou ao seu gerenciador de janela com um atalho.

## Opcional: Adicionar Fontes Personalizadas
Caso queira personalizar seu sistema mais a fundo, você pode adicionar suas fontes em:
```
~/.local/share/fonts
```

Com isso, o Arch Linux estará configurado e pronto para uso com duas opções de ambientes leves e personalizaveis!