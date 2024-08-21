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
    sudo pacman -S yay > /dev/null 2>&1
fi

back=$(pwd)

# Actualización del sistema
echo -e "${redColour}\n\n\[!]Updating system, please wait..."
yay -Syu --noconfirm > /dev/null 2>&1

echo -e "${greenColour}What do you want to install first?${endColour}"
echo -e "\n\t1) Aesthetics"
echo -e "\n\t2) Tools"
read replay

function aesthetics (){

cat << "EOF"                             
╔═╗┌─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐┬┌─┐┌─┐
╠═╣├┤ └─┐ │ ├─┤├┤  │ ││  └─┐
╩ ╩└─┘└─┘ ┴ ┴ ┴└─┘ ┴ ┴└─┘└─┘
EOF

# Selección de Window Manager
echo -e "${purpleColour}\n\n[!]Choose your window manager!${endColour}\n\n\t${greenColour}1) Awesome${endColour}\n\t${blueColour}2) Bspwm${endColour}"
read replay

if ! command -v ifconfig >/dev/null 2>&1; then 

    yay -S net-tools

fi


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

npah=$(pwd)
if [ "$npah" != "$back" ]; then
    cd "$back"
fi

# Instalación de eww
echo -e "${greenColour}\n\n[!]Installing eww${endColour}"
sleep 3 

yay -S rust cargo
git clone https://github.com/elkowar/eww > /dev/null 2>&1
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

npah=$(pwd)
if [ "$npah" != "$back" ]; then
    cd "$back"
fi

# Instalación de Kitty
if ! command -v kitty >/dev/null 2>&1; then
    echo -e "${greenColour}Installing a kitten!${endColour}"
    sleep 3
    yay -S kitty >/dev/null 2>&1
fi

#Installing picom

yay -S picom >/dev/null 2>&1
cd picom-jonaburg-fix
meson --buildtype=release . build >/dev/null 2>&1
ninja -C build >/dev/null 2>&1
LDFLAGS="-L/path/to/libraries" CPPFLAGS="-I/path/to/headers" meson --buildtype=release . build >/dev/null 2>&1
# To install the binaries in /usr/local/bin (optional)
sudo ninja -C build install >/dev/null 2>&1
mkdir -p $HOME/.config/picom
cp picom.conf ~/.config/picom

if [ "$npah" != "$back" ]; then
    cd "$back"
fi

# Instalación de herramientas adicionales
yay -S feh polybar fastfetch focuswriter flameshot rofi waybar >/dev/null 2>&1

# Instalación de Powerlevel10k
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sudo echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
chsh -s $(which zsh)
cp .p10k.zhs ~/

# Root Powerlevel10k
sudo sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root
chsh -s $(which zsh)
cp .p10k.zhs /root

#Fonts installing 

fonts=("Inconsolata.tar.xz" "Lekton.tar.xz" "Monofur.tar.xz" "NerdFontsSymbolsOnly.tar.xz" "VictorMono.tar.xz")

for font in "${fonts[@]}"; do
    echo -e "${greenColour}Extracting $font...${endColour}"

    # Extraer .tar.xz para obtener el archivo .tar
    tar -xf "$font" >/dev/null 2>&1

    # Obtener el nombre del archivo .tar
    tarFile="${font%.xz}" >/dev/null 2>&1

    # Extraer el archivo .tar
    tar -xf "$tarFile" >/dev/null 2>&1

    # Limpiar el archivo .tar
    rm "$tarFile" >/dev/null 2>&1

    echo -e "${greenColour}$font extracted successfully!${endColour}"
    sleep 3
done

npah=$(pwd)
if [ "$npah" != "$back" ]; then
    cd "$back"
fi

cp -r backgrounds ${HOME}
cp -r polybar bin kitty fastfetch~/.config 
mkdir -p $HOME/.config/fastfetch
cp -r backgrounds ~/

cd $back

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

sleep 3

mkdir -p hackTools
cd hackTools

# Instalación de Black Arch y herramientas

echo -e "\n\n${grayColour}Installing black arch over current distro${endColour}"
curl -O https://blackarch.org/strap.sh >/dev/null 2>&1
echo 26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh | sha1sum -c >/dev/null 2>&1
chmod +x strap.sh
sudo ./strap.sh >/dev/null 2>&1

tools=("nmap" "whatweb" "nikto" "go" "gobuster" "feroxbuster" "burpsuite" "autorecon" "fuff" "netdiscover" "anubis" "arp-scan" "anti-xss" "enum4linux" "exploit-db" "crawley-bin" "wfuzz")
LOG_FILE="error.data"

for tool in "${tools[@]}"; do
    echo "Instalando $tool..."
    sleep 3
    yay -S --noconfirm "$tool" >/dev/null 2>&1

    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[!]Error: $tool can't be installed, added to the error.data log"
        sleep 3
        echo "$tool is not installed" | tee -a "$LOG_FILE"
    fi
done

# Instalación de herramientas externas

sudo git clone https://github.com/drwetter/testssl.sh.git >/dev/null 2>&1
sudo git clone https://github.com/hatRiot/clusterd >/dev/null 2>&1
go install github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1
sudo git clone https://github.com/21y4d/nmapAutomator >/dev/null 2>&1

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

sleep 3

echo -e "${blueColour}\n\nInstalling AwesomeWM for you!${endColour}"

echo -e "${redColour}\n\nWARNING!${endColour}"
echo -e "${redColour}\n\nThis is only the base version, no configurations included!!${endColour}"
sleep 3
 
yay -S awesome vicious xcompmgr feh lxappearance xorg-setxkbmap >/dev/null 2>&1
mkdir ~/.config/awesome && cp /etc/xdg/awesome/rc.lua ~/.config/awesome/ 

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

echo -e "${blueColour}\n\nInstalling BSPWM for you!${endColour}"
sleep 3

yay -S bspwm sxhkd calcurse todotxt \
       jq dunst betterlockscreen brightnessctl playerctl maim \
       xclip imagemagick >/dev/null 2>&1

echo -e "${blueColour}Installing...${endColour}"

mkdir -p $HOME/.config/bspwm 
mkdir -p $HOME/.config/sxhkd
mkdir -p $HOME/.config/bspwm/scripts

chmod +x bspwmrc 
chmod +x sxhkdrc
chmod +x bspwm_resize

cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/
cp bspwm_resize ~/.config/sxhkd/scripts

cd ~/.config/bspwm 
sed -i -e 's/\r$//' bspwmrc
echo -e "${blueColour}Done!${endColour}"
cd $back 


}

function waylandEww(){

    cargo build --release --no-default-features --features=wayland > /dev/null 2>&1
    cd target/release
    chmod +x ./eww
    echo -e "${greenColour}\n\nDone installing Eww!${endColour}"
    sleep 3
    cd $back
    
}

function normalEww(){

    cargo build --release --no-default-features --features x11 > /dev/null 2>&1
    cd target/release
    chmod +x ./eww
    echo -e "${greenColour}\n\nDone installing Eww!${endColour}"
    sleep 3
    cd $back
    

}


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



