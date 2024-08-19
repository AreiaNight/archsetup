#!/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

cat << "EOF"
▄▄▄       ██▀███  ▓█████  ██▓ ▄▄▄       ███▄    █  ██▓  ▄████  ██░ ██ ▄▄▄█████▓
▒████▄    ▓██ ▒ ██▒▓█   ▀ ▓██▒▒████▄     ██ ▀█   █ ▓██▒ ██▒ ▀█▒▓██░ ██▒▓  ██▒ ▓▒
▒██  ▀█▄  ▓██ ░▄█ ▒▒███   ▒██▒▒██  ▀█▄  ▓██  ▀█ ██▒▒██▒▒██░▄▄▄░▒██▀▀██░▒ ▓██░ ▒░
░██▄▄▄▄██ ▒██▀▀█▄  ▒▓█  ▄ ░██░░██▄▄▄▄██ ▓██▒  ▐▌██▒░██░░▓█  ██▓░▓█ ░██ ░ ▓██▓ ░ 
 ▓█   ▓██▒░██▓ ▒██▒░▒████▒░██░ ▓█   ▓██▒▒██░   ▓██░░██░░▒▓███▀▒░▓█▒░██▓  ▒██▒ ░ 
 ▒▒   ▓▒█░░ ▒▓ ░▒▓░░░ ▒░ ░░▓   ▒▒   ▓▒█░░ ▒░   ▒ ▒ ░▓   ░▒   ▒  ▒ ░░▒░▒  ▒ ░░   
  ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ░  ░ ▒ ░  ▒   ▒▒ ░░ ░░   ░ ▒░ ▒ ░  ░   ░  ▒ ░▒░ ░    ░    
  ░   ▒     ░░   ░    ░    ▒ ░  ░   ▒      ░   ░ ░  ▒ ░░ ░   ░  ░  ░░ ░  ░      
      ░  ░   ░        ░  ░ ░        ░  ░         ░  ░        ░  ░  ░  ░         
                                                                                
                    ▀                      ▀                                  
EOF

#Ctrl C función para salir
function ctrl_c(){
    echo -e "\n[!] Saliendo...\n"
    tput cnorm
    exit 1
}

# Capturar Ctrl+C
trap ctrl_c SIGINT

# Instalación de yay
if ! command -v yay > /dev/null 2>&1; then
    echo -e "${greenColour}Installing yay${endColour}"
    sudo pacman -S yay
fi

back=$(pwd)

# Actualización del sistema
echo -e "${redColour}\n\n\[!]Updating system, please wait..."
yay -Syu --noconfirm

echo -e "What do you want to install first?"
echo -e "\n\t1) Aesthetics"
echo -e "\n\t2) Tools"
read replay

case $replay in
    1)
        aesthetics
        toolsHack
        ;;
    2)
        toolsHack
        aesthetics
        ;;
    *)
        echo -e "${redColour}\nNon an option, sorry! Exiting!${endColour}"
        exit 1
        ;;
esac 

cat << "EOF"   
DONE!
*  **
 **  
     
     
     
     
*    
  ** 
 *   
    *
    *

EOF   

function aesthetics (){

cat << "EOF"                             
╔═╗┌─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐┬┌─┐┌─┐
╠═╣├┤ └─┐ │ ├─┤├┤  │ ││  └─┐
╩ ╩└─┘└─┘ ┴ ┴ ┴└─┘ ┴ ┴└─┘└─┘
EOF

sleep 1

# Selección de Window Manager
echo -e "${purpleColour}\n\n[!]Choose your window manager!${endColour}\n\n\t${greenColour}1) Awesome${endColour}\n\t${blueColour}2) Bspwm${endColour}"
read replay

# Casos para la selección del Window Manager
case $replay in
    1)
        awesomneInstaller
        ;;
    2)
        bspwmInstaller
        ;;
    *)
        echo -e "${redColour}\nNon an option, sorry! Exiting!${endColour}"
        exit 1
        ;;
esac

# Instalación de eww
echo -e "${greenColour}\n\n[!]Installing eww${endColour}"
yay -S rust cargo
git clone https://github.com/elkowar/eww
cd eww

echo -e "${purpleColour}\n\nAre you using Wayland? (y/n)${endColour}"
read replay

case $replay in
    y)
        waylandEww
        ;;
    n)
        normalEww
        ;;
    *)
        echo -e "${redColour}\nNon an option, sorry! Exiting!${endColour}"
        exit 1
        ;;
esac

# Instalación de Kitty
if ! command -v kitty > /dev/null 2>&1; then
    echo -e "${greenColour}Installing a kitten!${endColour}"
    yay -S kitty
fi

# Instalación de Picom

echo -e "${blueColour}[!]\n\nPicom time${endColour}"

yay -S hicolor-icon-theme libconfig libdbus libepoxy libev libgl pcre2 pixman xcb-util-image xcb-util-renderutil dbus python xorg-xprop xorg-xwininfo asciidoc git mesa meson ninja setconf uthash

git clone https://github.com/FT-Labs/picom.git

cd picom

meson setup --buildtype=release build

LDFLAGS="-L/path/to/libraries" CPPFLAGS="-I/path/to/headers" meson setup --buildtype=release build

ninja -C build install

mkdir -p ~/.config/picom

cp picom.conf ~/.config/picom/

cd $back

# Instalación de herramientas adicionales
yay -S feh polybar focuswriter flameshot waybar

# Instalación de Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Root Powerlevel10k
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root

#Fonts installing 

fonts=("Inconsolata.tar.xz" "Lekton.tar.xz" "Monofur.tar.xz" "NerdFontsSymbolsOnly.tar.xz" "VictorMono.tar.xz")

for font in "${fonts[@]}"; do
    echo -e "${greenColour}Extracting $font...${endColour}"

    # Extraer .tar.xz para obtener el archivo .tar
    tar -xf "$font"

    # Obtener el nombre del archivo .tar
    tarFile="${font%.xz}"

    # Extraer el archivo .tar
    tar -xf "$tarFile"

    # Limpiar el archivo .tar
    rm "$tarFile"

    echo -e "${greenColour}$font extracted successfully!${endColour}"
done

}

function toolsHack () {

cat << "EOF"

                                                                  
@@@  @@@   @@@@@@    @@@@@@@  @@@  @@@  @@@  @@@  @@@   @@@@@@@@  
@@@  @@@  @@@@@@@@  @@@@@@@@  @@@  @@@  @@@  @@@@ @@@  @@@@@@@@@  
@@!  @@@  @@!  @@@  !@@       @@!  !@@  @@!  @@!@!@@@  !@@        
!@!  @!@  !@!  @!@  !@!       !@!  @!!  !@!  !@!!@!@!  !@!        
@!@!@!@!  @!@!@!@!  !@!       @!@@!@!   !!@  @!@ !!@!  !@! @!@!@  
!!!@!!!!  !!!@!!!!  !!!       !!@!!!    !!!  !@!  !!!  !!! !!@!!  
!!:  !!!  !!:  !!!  :!!       !!: :!!   !!:  !!:  !!!  :!!   !!:  
:!:  !:!  :!:  !:!  :!:       :!:  !:!  :!:  :!:  !:!  :!:   !::  
::   :::  ::   :::   ::: :::   ::  :::   ::   ::   ::   ::: ::::  
 :   : :   :   : :   :: :: :   :   :::  :    ::    :    :: :: :   
                                                                  

EOF

sleep 1

mkdir -p hackTools
cd hackTools

# Instalación de Black Arch y herramientas

echo -e "\n\n${grayColour}Installing black arch over current distro${endColour}"
curl -O https://blackarch.org/strap.sh
echo 26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh | sha1sum -c
chmod +x strap.sh
sudo ./strap.sh

tools=("nmap" "whatweb" "nikto" "go" "gobuster" "feroxbuster" "burpsuite" "autorecon" "fuff" "netdiscover" "anubis" "arp-scan" "anti-xss" "enum4linux" "exploit-db" "crawley-bin" "wfuzz")
LOG_FILE="error.data"

for tool in "${tools[@]}"; do
    echo "Instalando $tool..."
    yay -S --noconfirm "$tool"

    if ! command -v "$tool" > /dev/null 2>&1; then
        echo "[!]Error: $tool can't be installed, added to the error.data log"
        echo "$tool is not installed" | tee -a "$LOG_FILE"
    fi
done

# Instalación de herramientas externas

sudo git clone https://github.com/drwetter/testssl.sh.git
sudo git clone https://github.com/hatRiot/clusterd
go install github.com/projectdiscovery/katana/cmd/katana@latest
sudo git clone https://github.com/21y4d/nmapAutomator

cd $back

}

function awesomneInstaller (){

cat << "EOF"

 _______  _     _  _______  __   __ 
|   _   || | _ | ||       ||  |_|  |
|  |_|  || || || ||  _____||       |
|       ||       || |_____ |       |
|       ||       ||_____  ||       |
|   _   ||   _   | _____| || ||_|| |
|__| |__||__| |__||_______||_|   |_|


EOF

sleep 1

echo -e "${blueColour}\n\nInstalling AwesomeWM for you!${endColour}"

yay -S awesome

}

function bspwmInstaller (){

cat << "EOF"


██████╗ ███████╗██████╗ ██╗    ██╗███╗   ███╗
██╔══██╗██╔════╝██╔══██╗██║    ██║████╗ ████║
██████╔╝███████╗██████╔╝██║ █╗ ██║██╔████╔██║
██╔══██╗╚════██║██╔═══╝ ██║███╗██║██║╚██╔╝██║
██████╔╝███████║██║     ╚███╔███╔╝██║ ╚═╝ ██║
╚═════╝ ╚══════╝╚═╝      ╚══╝╚══╝ ╚═╝     ╚═╝
                                             

EOF

sleep 1

echo -e "${blueColour}\n\nInstalling Bspwm for you!${endColour}"

yay -S bspwm sxhkd polybar dunst rofi thunar
echo -e "${blueColour}\n\nInstalling the configuration!${endColour}"

git clone https://github.com/baskerville/bspwm.git
cd bspwm
make
sudo make install
cd $back
cd .config 
mkdir bspwm
mkdir sxhkd
cd $back
cp bspwmrc ~/.config/bspwm
cp sxhkdrc ~/.config/sxhkdr
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/sxhkdr

echo -e "${greenColour}\n\nConfiguración terminada!${endColour}"

cd $back

}
