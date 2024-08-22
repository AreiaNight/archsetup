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

# Progress bar

function ProgressBar {
    local steps=7
    local current_step=$1
    local progress=$((current_step * 100 / steps))
    local completed=$((progress / 2))
    local remaining=$((50 - completed))

    echo -ne "["
    for ((i=0; i<completed; i++)); do echo -ne "x"; done
    for ((i=0; i<remaining; i++)); do echo -ne "#"; done
    echo -ne "] $progress% (Step $current_step/$steps)\r"

    if [ "$progress" -eq 100 ]; then
        echo -ne '\n'
    fi
}


# Actualización del sistema
echo -e "${redColour}\n\n[!]Updating system, please wait... This will taka a while so why not go for a snack or pet your pets?"
sudo pacman -Syu --noconfirm


# Instalación de yay
if ! command -v yay > /dev/null 2>&1; then
    echo -e "${greenColour}Installing yay${endColour}"
    ProgressBar 2
    sudo pacman -S --noconfirm yay > /dev/null 2>&1
fi

back=$(pwd)
ProgressBar 1

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

    yay -S --noconfirm net-tools

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

yay -S --noconfirm rust cargo
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
if [ -z "$(command -v kitty)" ]; then
    echo -e "${greenColour}Installing a kitten!${endColour}"
    sleep 3
    yay -S --noconfirm kitty >/dev/null 2>&1
fi


#Installing picom

yay -S --noconfirm picom >/dev/null 2>&1
cd picom-jonaburg-fix
meson --buildtype=release . build >/dev/null 2>&1
ninja -C --noconfirm build >/dev/null 2>&1
LDFLAGS="-L/path/to/libraries" CPPFLAGS="-I/path/to/headers" meson --buildtype=release . build >/dev/null 2>&1
# To install the binaries in /usr/local/bin (optional)
sudo ninja -C --noconfirm build install >/dev/null 2>&1
mkdir -p $HOME/.config/picom
cp picom.conf ~/.config/picom

if [ "$npah" != "$back" ]; then
    cd "$back"
fi

# Instalación de herramientas adicionales
yay -S --noconfirm feh polybar fastfetch focuswriter flameshot rofi waybar ranger >/dev/null 2>&1

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

fonts=("ttf-space-mono-nerd" "ttf-monofur-nerd" "ttf-anonymouspro-nerd" "ttf-nerd-fonts-symbols-mono")

for font in "${fonts[@]}"; do
    yay -S --noconfirm $font >/dev/null 2>&1
    echo "Instalando $font"
done

cd polybar 
chmod +x launch.sh

npah=$(pwd)
if [ "$npah" != "$back" ]; then
    cd "$back"
fi

cp -r backgrounds ${HOME}
cp -r polybar bin kitty fastfetch~/.config 
mkdir -p $HOME/.config/fastfetch
cp -r backgrounds ~/

cd $back

ProgressBar 3

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
    echo "Installing $tool..."
    sleep 3
    yay -S --noconfirm "$tool" >/dev/null 2>&1

    if ! command -v "${greenColour}$tool${endColour}" >/dev/null 2>&1; then
        echo "[!]Error: $tool can't be installed, added to the error.data log"
        sleep 3
        echo "${redColour}$tool is not installed${endColour}" | tee -a "$LOG_FILE"
    fi
done

# Instalación de herramientas externas

sudo git clone https://github.com/drwetter/testssl.sh.git >/dev/null 2>&1
echo -e "\nInstallng TestSSL\n"
sudo git clone https://github.com/hatRiot/clusterd >/dev/null 2>&1
echo -e "Installing Clustered\n"
go install github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1
echo -e "Installing Katana\n"
sudo git clone https://github.com/21y4d/nmapAutomator >/dev/null 2>&1
echo -e "Installing nmapAutomator\n"

cd $back

ProgressBar 2

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
 
yay -S --noconfirm awesome vicious xcompmgr feh lxappearance xorg-setxkbmap >/dev/null 2>&1
mkdir ~/.config/awesome && cp /etc/xdg/awesome/rc.lua ~/.config/awesome/ 

ProgressBar 5

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

yay -S --noconfirm bspwm sxhkd calcurse todotxt \
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

ProgressBar 5

}

function waylandEww(){

    
    cargo build --release --no-default-features --features=wayland >/dev/null 2>&1
    cd target/release
    chmod +x ./eww
    echo -e "${greenColour}\n\nDone installing Eww!${endColour}"
    sleep 3
    cd $back
    
    ProgressBar 6
    
}

function normalEww(){
    
    
    cargo build --release --no-default-features --features x11 >/dev/null 2>&1
    cd target/release
    chmod +x ./eww
    echo -e "${greenColour}\n\nDone installing Eww!${endColour}"
    sleep 3
    cd $back
    ProgressBar 6

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

echo -e "${greenColour}Done!${endColour}"

ProgressBar 7

