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

sleep 3

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
sleep 3

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
    sleep 3
    yay -S kitty
fi

# Instalación de Picom

echo -e "${blueColour}[!]\n\nPicom time${endColour}"
sleep 3

yay -S hicolor-icon-theme libconfig libdbus libepoxy libev libgl pcre2 pixman xcb-util-image xcb-util-renderutil dbus python xorg-xprop xorg-xwininfo asciidoc git mesa meson ninja setconf uthash
git clone https://github.com/FT-Labs/picom.git

cd picom

meson setup --buildtype=release build
LDFLAGS="-L/path/to/libraries" CPPFLAGS="-I/path/to/headers" meson setup --buildtype=release build
ninja -C build install
cd $back
mkdir -p ~/.config/picom
cp picom.conf ~/.config/picom/


# Instalación de herramientas adicionales
yay -S feh polybar focuswriter flameshot waybar

# Instalación de Powerlevel10k
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sudo echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Root Powerlevel10k
sudo sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root

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
    sleep 3
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

sleep 3

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
    sleep 3
    yay -S --noconfirm "$tool"

    if ! command -v "$tool" > /dev/null 2>&1; then
        echo "[!]Error: $tool can't be installed, added to the error.data log"
        sleep 3
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

sleep 3

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

sleep 3

#BSPWM AUTO INSTALLER BY: https://github.com/theduckchannel/duckchannel-style-bspwm.git

import os
import sys
import configparser
import time
import subprocess as sp

cp = configparser.ConfigParser(allow_no_value=True)
cp.read('packages.ini')
username = sp.getoutput('whoami')


def cprint( fmt, fg=None, bg=None, style=None ):
    """
    Colour-printer.

        cprint( 'Hello!' )                                  # normal
        cprint( 'Hello!', fg='g' )                          # green
        cprint( 'Hello!', fg='r', bg='w', style='bx' )      # bold red blinking on white

    List of colours (for fg and bg):
        k   black
        r   red
        g   green
        y   yellow
        b   blue
        m   magenta
        c   cyan
        w   white

    List of styles:
        b   bold
        i   italic
        u   underline
        s   strikethrough
        x   blinking
        r   reverse
        y   fast blinking
        f   faint
        h   hide
    """

    COLCODE = {
        'k': 0, # black
        'r': 1, # red
        'g': 2, # green
        'y': 3, # yellow
        'b': 4, # blue
        'm': 5, # magenta
        'c': 6, # cyan
        'w': 7  # white
    }

    FMTCODE = {
        'b': 1, # bold
        'f': 2, # faint
        'i': 3, # italic
        'u': 4, # underline
        'x': 5, # blinking
        'y': 6, # fast blinking
        'r': 7, # reverse
        'h': 8, # hide
        's': 9, # strikethrough
    }

    # properties
    props = []
    if isinstance(style,str):
        props = [ FMTCODE[s] for s in style ]
    if isinstance(fg,str):
        props.append( 30 + COLCODE[fg] )
    if isinstance(bg,str):
        props.append( 40 + COLCODE[bg] )

    # display
    props = ';'.join([ str(x) for x in props ])
    if props:
        print( '\x1b[%sm%s\x1b[0m' % (props, fmt) )
    else:
        print( fmt )



def cmd(parameter):
    os.system(parameter)
    

def pause():
    time.sleep(3)


def saveLxdmConf():
    with open('lxdm.conf', 'w') as configfile:
        lxdmCp.write(configfile)



def showWelcomeScreen():
    cprint('===========================================================', fg='y', style='b')
    cprint(':: The Duck Channel´s bspwm Style ::', fg='g', style='b')
    cprint('https://github.com/theduckchannel/bspwm-install', fg='c', style='b')
    cprint('===========================================================', fg='y', style='b')
    pause()

 

def installXorg():
    cprint('\r\n\r\n:: Installing xorg...', fg='y', style='b')    
    os.system('sudo pacman --noconfirm -S xorg')
    pause()


def installLxdm(): 
    cprint('\r\n\r\n:: Installing Lxdm...', fg='y', style='b') 
    # install and enable lxdm   
    os.system('sudo pacman --noconfirm -S lxdm')
    os.system('sudo systemctl enable lxdm')
    # Copy lxdm.conf to local copy
    os.system('cp /etc/lxdm/lxdm.conf .')
    os.system(f'sed -i "s/# autologin=dgod/autologin={username}/" lxdm.conf')
    os.system('sed -i "s/# numlock=0/numlock=1/" lxdm.conf')
    os.system('sed -i "s/# session=\/usr\/bin\/startlxde/session=\/usr\/bin\/bspwm/" lxdm.conf')
    os.system('sudo cp -f lxdm.conf /etc/lxdm/lxdm.conf')
    os.system('rm lxdm.conf')
    pause()
    

def installRegularPackages():
    cprint('\r\n:: Installing Regular packages...', fg='y', style='b')
    regPkgs = ''
    for pkg in cp['Regular']:
        regPkgs = regPkgs + pkg + ' '

    print(regPkgs)
    os.system(f'sudo pacman --noconfirm -S {regPkgs}')
    pause()

def installYayAurHelper():
    cprint('\r\n:: Install Yay AUR Helper...', fg='y', style='b')
    os.system('git clone https://aur.archlinux.org/yay.git') 
    os.chdir('yay')
    os.system('makepkg -si')
    os.chdir('../')
    os.system('rm -rf yay')
    pause()

def installAurPkgs():
    cprint('\r\n:: Installing AUR packages...', fg='y', style='b')
    for pkg in cp['AUR']:
        os.system(f'yay --noconfirm -S {pkg}')

    pause()


def installDotFiles():
    # if ~/.config not exists, so create
    cprint('\r\n:: Installing dotfiles...', fg='y', style='b')
    if(not os.path.isdir(f'/home/{username}/.config')):
        os.mkdir(f'/home/{username}/.config')
    
    os.system(f'cp -rf {os.getcwd()}/dotfiles/.config/* /home/{username}/.config')
    os.system(f'cp -rf {os.getcwd()}/dotfiles/.Xre* /home/{username}/')
    os.system(f'cp -rf {os.getcwd()}/dotfiles/.xs* /home/{username}/')
    os.system(f'cp -rf {os.getcwd()}/dotfiles/.fe* /home/{username}/')
    os.system(f'cp -rf {os.getcwd()}/dotfiles/.vimrc /home/{username}/')
    pause()


def updateAndUpgrade():
    cprint('\r\n:: Update and Upgrading your system...', fg='y', style='b')
    os.system('sudo pacman --noconfirm -Syyu')

def showFinalMessage():
    cprint('\r\n:: Everything ok...', fg='y', style='b')
    input('Press any key to REBOOT!')
    os.system('reboot')


def installGrubTheme():
    cprint('\r\n:: Installing Grub Theme...', fg='y', style='b')
    os.system(f'sudo cp -rf {os.getcwd()}/grub-themes/XeroComp /boot/grub/themes')
    os.system(f'cp /etc/default/grub .')
    os.system("sed -i 's/#GRUB_THEME=.*/GRUB_THEME=\"\/boot\/grub\/themes\/XeroComp\/theme.txt\"/' grub") 
    os.system('sudo cp -f grub /etc/default/grub')
    os.system('sudo grub-mkconfig -o /boot/grub/grub.cfg')
    os.system('rm grub')


def polyBarConfig():
    cprint('\r\n:: Polybar Config...', fg='y', style='b')
    os.system('./polybar-config.sh')
    

def main():
    showWelcomeScreen()
    updateAndUpgrade()
    installXorg()
    installLxdm()
    installRegularPackages()
    installYayAurHelper()
    installAurPkgs()
    installDotFiles()
    installGrubTheme()
    polyBarConfig()
    showFinalMessage()
    

if __name__ == "__main__":
    main()


}

function waylandEww(){

    cargo build --release --no-default-features --features=wayland
    cd target/release
    chmod +x ./eww
    cd ~/archSetup
    echo -e "${greenColour}\n\nDone installing Eww!${endColour}"
    sleep 3
    cd $back
    
}

function normalEww(){

    cargo build --release --no-default-features --features x11
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
