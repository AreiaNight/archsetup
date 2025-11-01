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

# Define color variables para ASCII
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


cat << 'EOF'
%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%                                             %%%%%%%%%%%%%%%%%%%%%%%%
#####%%%%%%%%%%%%%%%%%%%%%%%%%%%                *         %                %%%%%%%%%%%%%%%%%########
###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 %      %                  %%%%%%%%%%%%%############
####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               #%     *%                  %%%%######%%%%%%#########
####%%###%%%%%%#####%#%%%%%%%%%%*           #%%%%  *### #%%%              %%%%%###########+#%%%#####
#################%%%%%%######%%#%           +#%%%%%%%%%%##%%%%            %%%%%###+###########%%%###
#############%%%%#############%#%*          +**#%%%%%%%%%%%%%%           %%%#############*#######%%%
###########%%####################%             **#%+++*%%%#             #%%####%##*##*##############
########%%#######################%%            ***%%++%#%*%#           ##%#####%##**##-#############
######%%##################**#****#%#    +*    :%%=+++++*%%%#*         ##%##*#####****=*#############
####%#########***-*##**#**********#%* =+*##** %%%#-+%**#%%%   %%    *###*****+=*+***=+***###########
##%##############**********#***+++###*=  +*%%%%%%#+-=*#% * #%%%%  +###***********#**#*+*#####       
%####          *##********+***+++++*##*   %--%=+*=++#%%% ###%%%%%###***********+*#**-**####         
##               ***+******#+++++++++***  ####%#*%%%%%%%%%%%%%#%%%%++++*****+*+***=+**####          
                    +=+**-***+=+++++===+*#*##..:+##=##%%%%%%%##%%%%+++++++++++:=+*==*###   % %%%%   
                    +*+**+**++++=-::-:::**=+*#%*%+****#%%%%%%%%%###%%#*+++++=-=#=:.####         %#  
                    ++++=***+++++===-:.**%##%%##%%%%%%%%%%%%%%%%%%%%%%%+++++=#==#=####              
                    +=-+=-#*+++++++-=+*+%%%%%%%%%%%%%%%%%%%%%%%%%%%========#*+###*###               
                    **-*:++*+++++++=   =#%##%%%%%%%%%#######=+%%%##%=*##*%%%%%**##%#                
                       *###**######=:###%##+#%%%%%%%##%####--=*#%%%#%###%%%#***#*%%                 
                           #%%%%###%%%%%#*+=#%%%%%%%#%####:::-= #%%%%%%%%       #%%                 
                                #%%%%%##   +#%%%%%%%%%%%%        %%%%%%          %                  
                                    * ##    *%%%%%%%%%%#%        #               %                  
                                      +    ++#%%%%%%%%#%%% %%%                                      
                                       %% *##%%%%%%%%%%#%#%%%%                                      
  *###***###***+                       #%##%%#%%%%%%%%%%%%%%%%                                      
###*#     ######*####                  ###%%%%%%%%%%%%%%%%%%%%#                                     
                 ####**##            * ####%%%%%%%%%%%%%%%%%%%%                                     
                     ###****         +*#%%%%%%%%%%%%%%%%%%%%%%%%                                    
               #%%%%%   ***+**     --##%#%%%%%%%%%%%%%%%%%%%%%%%%                                                  
EOF

#Ctrl C función para salir
function ctrl_c(){
    echo -e "\n[!] Saliendo...\n"
    tput cnorm
    exit 1
}

# Capturar Ctrl+C
trap ctrl_c SIGINT



# Actualización del sistema
echo -e "${redColour}\n\n[!]Updating system, please wait... This will taka a while so why not go for a snack or pet your pets?"
sudo pacman -Syu --noconfirm > /dev/null 2>&1


# Instalación de yay
if ! command -v yay > /dev/null 2>&1; then
    echo -e "${greenColour}Installing yay${endColour}"
    sudo pacman -S --noconfirm yay > /dev/null 2>&1
fi

back=$(pwd)


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


cd polybar 
cd chmod +x launch.sh
cd ..
cd bin 
chmod +x aphrodite.sh ethernet_status.sh htb_status.sh htb_target.sh
cd ..

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


# Installing picom
echo -e "${purpleColour}\n\nInstalling picom!${endColour}"

# Detectar si es máquina virtual
if systemd-detect-virt -q 2>/dev/null; then
    VM_TYPE=$(systemd-detect-virt)
    echo -e "${yellowColour}Detected virtual machine: $VM_TYPE${endColour}"
    IS_VM=true
else
    IS_VM=false
fi

# Instalar dependencias necesarias primero
yay -S --noconfirm meson ninja gcc cmake libxext libxcb xcb-util-renderutil xcb-util-image xcb-util-glx >/dev/null 2>&1

# Instalar picom base desde repositorio
yay -S --noconfirm picom >/dev/null 2>&1

# Clonar y compilar picom-jonaburg con animaciones
git clone https://github.com/jonaburg/picom.git picom-jonaburg >/dev/null 2>&1
cd picom-jonaburg
git submodule update --init >/dev/null 2>&1

# Compilar correctamente
meson setup --buildtype=release build >/dev/null 2>&1
ninja -C build >/dev/null 2>&1
sudo ninja -C build install >/dev/null 2>&1

# Crear directorio de configuración
mkdir -p $HOME/.config/picom
cp picom.confi $HOME/.config/picom

# Volver al directorio original
cd "$back"

# Configuración basada en el tipo de sistema
if [ "$IS_VM" = true ]; then
    echo -e "${yellowColour}Creating VM-optimized picom configuration...${endColour}"
    cat > ~/.config/picom/picom.conf << 'EOF'
# VM-optimized picom configuration
backend = "xrender"
vsync = true
use-damage = false

# Deshabilitar características pesadas para VM
animations = false
shadow = false
fading = false
blur: { method = "none"; }
corner-radius = 0

# Configuración de rendimiento para VM
glx-no-stencil = true
glx-no-rebind-pixmap = true
xrender-sync-fence = true

# Excluir todo problemático en VM
shadow-exclude = [ "all" ]
fade-exclude = [ "all" ]
blur-background-exclude = [ "all" ]
focus-exclude = [ "all" ]

# Opacidad básica
inactive-opacity = 1.0
active-opacity = 1.0
frame-opacity = 1.0

# Detección
detect-rounded-corners = false
detect-client-opacity = true

# Log level
log-level = "warn"
EOF
else
    echo -e "${greenColour}Creating standard picom configuration with animations...${endColour}"
    cp picom.conf ~/.config/picom/
fi

echo -e "${greenColour}Picom installed successfully!${endColour}"
echo -e "${blueColour}Configuration: ${endColour}$([ "$IS_VM" = true ] && echo "VM-optimized" || echo "Full features")"


# Instalación de herramientas adicionales
packs=("feh" "polybar" "fastfetch" "ghostwriter" "flameshot" "rofi" "ranger")

LOG_FILE="errorAesthetics.data"

for pack in "${packs[@]}"; do

    echo -e "Installing $pack..."
    
    yay -S --noconfirm "$pack" >/dev/null 2>&1
    
    if [ -z "$(command -v $pack)" ]; then
    
        echo -e "${greenColour}[!] Something went wrong, $pack is not installed. Try again manually ${endColour}" >> errorAesthetics.data
    fi
    
    echo -e "${greenColour}$pack is installed${endColour}"
    
done

# Instalación de Powerlevel10k
echo -e "${greenColour}/n[!]Installing powerlevel10k for user ${endColour}" 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
yay -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
chsh -s $(which zsh)

# Root Powerlevel10k
echo -e "${greenColour}/n[!]Installing powerlevel10k for root ${endColour}" 
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
sudo sh -c 'echo "source /root/powerlevel10k/powerlevel10k.zsh-theme" >> /root/.zshrc'
sudo sh -c 'echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /root/.zshrc'
sudo sh -c 'echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /root/.zshrc'
echo "Cambiando shell de root a zsh..."
sudo chsh -s $(which zsh) root

#Fonts installing 

pacman -S nerd-fonts

cd polybar 
chmod +x launch.sh

npah=$(pwd)
if [ "$npah" != "$back" ]; then
    cd "$back"
fi

cp -r backgrounds ${HOME}
mkdir -p $HOME/.config/fastfetch
cp -r polybar bin kitty fastfetch ~/.config 
cp -r backgrounds ~/
cd backgrounds 
cp picture.png ~/.config/fastfetch
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

mkdir -p hackTools
cd hackTools

# Instalación de Black Arch y herramientas

echo -e "\n\n${grayColour}Installing black arch over current distro${endColour}"
curl -O https://blackarch.org/strap.sh >/dev/null 2>&1
echo 26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh | sha1sum -c >/dev/null 2>&1
chmod +x strap.sh
sudo ./strap.sh >/dev/null 2>&1

tools=("nmap" "whatweb" "nikto" "go" "gobuster" "feroxbuster" "librewolf" "zen-browser" "burpsuite" "autorecon" "fuff" "netdiscover" "anubis" "arp-scan" "anti-xss" "enum4linux" "exploit-db" "crawley-bin" "wfuzz" "seclists")

LOG_FILE="error.data"

for tool in "${tools[@]}"; do
    echo "Installing $tool..."

    # Intenta instalar la herramienta
    yay -S --noconfirm "$tool" >/dev/null 2>&1

    # Verifica si la herramienta fue instalada correctamente
    if command -v "$tool" >/dev/null 2>&1; then
        echo -e "${turquoiseColour} $tool is installed${endColour}"
    else
        echo -e "${redColour} $tool is not installed${endColour}" | tee -a "$LOG_FILE"
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

# Instalando seclists y más diccionarios 
echo -e "Do you want to install wordlists? (y/n)"
read wrds

if [ "$wrds" == "y" ]; then 
    sudo mkdir -p /usr/share/wordlists
    cd /usr/share/wordlists || exit
    sudo git clone https://github.com/danielmiessler/SecLists.git
    sudo git clone https://github.com/berzerk0/Probable-Wordlists.git
fi

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

echo -e "${blueColour}\n\nInstalling AwesomeWM for you!${endColour}"

echo -e "${redColour}\n\nWARNING!${endColour}"
echo -e "${redColour}\n\nThis is only the base version, no configurations included!!${endColour}"
sleep 3
 
yay -S --noconfirm awesome vicious xcompmgr feh lxappearance xorg-setxkbmap >/dev/null 2>&1
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

yay -S --noconfirm bspwm sxhkd calcurse todotxt \
       jq dunst betterlockscreen brightnessctl playerctl maim \
       xclip imagemagick >/dev/null 2>&1

echo -e "${blueColour}Installing...${endColour}"

mkdir -p $HOME/.config/bspwm 
mkdir -p $HOME/.config/sxhkd
mkdir -p $HOME/.config/bspwm/scripts

echo -e "${blueColour}\nAlmost there!${endColour}"
chmod +x bspwmrc 
chmod +x sxhkdrc
chmod +x bspwm_resize

cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/
cp bspwm_resize ~/.config/bspwm/scripts

echo -e "${blueColour}\nJust a little longer!${endColour}"
cd ~/.config/bspwm 
sed -i -e 's/\r$//' bspwmrc
echo -e "${blueColour}Done!${endColour}"
cd $back 



}



