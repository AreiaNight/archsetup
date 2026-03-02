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

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'


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

function ctrl_c(){
    echo -e "\n[!] Saliendo...\n"
    tput cnorm
    exit 1
}

trap ctrl_c SIGINT

echo -e "${redColour}\n\n[!] Updating system, please wait... This will take a while so why not go for a snack or pet your pets?${endColour}"
sudo pacman -Syu --noconfirm > /dev/null 2>&1

# Instalación de yay
if ! command -v yay > /dev/null 2>&1; then
    echo -e "${greenColour}Installing yay${endColour}"
    sudo pacman -S --needed --noconfirm git base-devel > /dev/null 2>&1
    git clone https://aur.archlinux.org/yay.git /tmp/yay > /dev/null 2>&1
    cd /tmp/yay && makepkg -si --noconfirm > /dev/null 2>&1
    cd -
fi

back=$(pwd)

echo -e "${greenColour}What do you want to install first?${endColour}"
echo -e "\n\t1) Aesthetics"
echo -e "\n\t2) Tools"
read replay

function aesthetics(){

cat << "EOF"
╔═╗┌─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐┬┌─┐┌─┐
╠═╣├┤ └─┐ │ ├─┤├┤  │ ││  └─┐
╩ ╩└─┘└─┘ ┴ ┴ ┴└─┘ ┴ ┴└─┘└─┘
EOF

cd polybar
chmod +x launch.sh
cd ..
cd bin
chmod +x aphrodite.sh ethernet_status.sh htb_status.sh htb_target.sh
cd ..

if ! command -v ifconfig >/dev/null 2>&1; then
    yay -S --noconfirm net-tools
fi

bspwmInstaller

[ "$(pwd)" != "$back" ] && cd "$back"

# ──── Picom ───────────────────────────────────────────────────────────────────
echo -e "${purpleColour}\n\nInstalling picom!${endColour}"

sudo pacman -S --noconfirm --needed \
    libx11 libxext libxrender libxrandr libxi libxdamage libxcomposite \
    libxfixes xorgproto xcb-util-renderutil xcb-util-image pixman \
    dbus libconfig libev uthash pcre2 meson ninja cmake gcc > /dev/null 2>&1

yay -S --noconfirm picom-git > /dev/null 2>&1

mkdir -p "$HOME/.config/picom"
cp picom.conf ~/.config/picom/

[ "$(pwd)" != "$back" ] && cd "$back"

# ──── Paquetes estéticos ──────────────────────────────────────────────────────
packs=("feh" "polybar" "fastfetch" "ghostwriter" "flameshot" "rofi" "ranger")
LOG_FILE="errorAesthetics.data"

for pack in "${packs[@]}"; do
    echo -e "Installing $pack..."
    yay -S --noconfirm "$pack" >/dev/null 2>&1

    if ! command -v "$pack" >/dev/null 2>&1; then
        echo -e "${redColour}[!] $pack not installed. Try manually.${endColour}" >> "$LOG_FILE"
    else
        echo -e "${greenColour}$pack is installed${endColour}"
    fi
done

# ──── Powerlevel10k ───────────────────────────────────────────────────────────
if ! command -v zsh >/dev/null 2>&1; then
    yay -S --noconfirm zsh >/dev/null 2>&1
fi

yay -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions >/dev/null 2>&1

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k > /dev/null 2>&1
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
cp .p10k.zsh ~/
chsh -s "$(which zsh)"

sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k > /dev/null 2>&1
sudo bash -c 'echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >> /root/.zshrc'
sudo bash -c 'echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /root/.zshrc'
sudo bash -c 'echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /root/.zshrc'

# ──── Fuentes ─────────────────────────────────────────────────────────────────
fonts=("ttf-space-mono-nerd" "ttf-monofur-nerd" "ttf-anonymouspro-nerd" "ttf-nerd-fonts-symbols-mono")
for font in "${fonts[@]}"; do
    yay -S --noconfirm "$font" >/dev/null 2>&1
    echo "Instalando $font"
done

# ──── Copiar configs ──────────────────────────────────────────────────────────
cd polybar && chmod +x launch.sh
[ "$(pwd)" != "$back" ] && cd "$back"

cp -r backgrounds "${HOME}"
mkdir -p "$HOME/.config/fastfetch"
cp -r polybar bin kitty fastfetch ~/.config
cp -r backgrounds ~/
cd backgrounds && cp picture.png ~/.config/fastfetch
cd "$back"

echo "Do you want to install hack tools? (y/n)"
read aswrs
[[ "$aswrs" == "y" ]] && toolsHack

}

function toolsHack(){

cat << "EOF"

@@@  @@@   @@@@@@    @@@@@@@  @@@  @@@  @@@  @@@@ @@@  @@@@@@@@  
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

echo -e "\n\n${grayColour}Installing BlackArch repo over current distro${endColour}"
curl -O https://blackarch.org/strap.sh >/dev/null 2>&1
echo "26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh" | sha1sum -c >/dev/null 2>&1
chmod +x strap.sh
sudo ./strap.sh >/dev/null 2>&1

tools=("nmap" "whatweb" "nikto" "go" "gobuster" "feroxbuster" "librewolf-bin" "zen-browser-bin" \
       "burpsuite" "autorecon" "ffuf" "netdiscover" "anubis" "arp-scan" \
       "enum4linux-ng" "exploitdb" "wfuzz" "seclists" "sqlmap" "metasploit")

LOG_FILE="error.data"

for tool in "${tools[@]}"; do
    echo "Installing $tool..."
    yay -S --noconfirm "$tool" >/dev/null 2>&1

    bin_name="${tool%-bin}"
    bin_name="${bin_name%-ng}"
    if command -v "$bin_name" >/dev/null 2>&1; then
        echo -e "${turquoiseColour} $tool is installed${endColour}"
    else
        echo -e "${redColour} $tool might not be in PATH — check manually${endColour}" | tee -a "$LOG_FILE"
    fi
done

# Herramientas externas
sudo git clone https://github.com/drwetter/testssl.sh.git >/dev/null 2>&1
echo -e "\nInstalling TestSSL\n"

sudo git clone https://github.com/hatRiot/clusterd >/dev/null 2>&1
echo -e "Installing Clusterd\n"

go install github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1
echo -e "Installing Katana\n"

sudo git clone https://github.com/21y4d/nmapAutomator >/dev/null 2>&1
echo -e "Installing nmapAutomator\n"

echo -e "Do you want to install wordlists? (y/n)"
read wrds
if [ "$wrds" == "y" ]; then
    sudo mkdir -p /usr/share/wordlists
    cd /usr/share/wordlists || exit
    sudo git clone https://github.com/danielmiessler/SecLists.git
    sudo git clone https://github.com/berzerk0/Probable-Wordlists.git
fi

cd "$back"

echo "Do you want to install aesthetics? (y/n)"
read aswrs
[[ "$aswrs" == "y" ]] && aesthetics

}

function bspwmInstaller(){

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

mkdir -p "$HOME/.config/bspwm"
mkdir -p "$HOME/.config/sxhkd"
mkdir -p "$HOME/.config/bspwm/scripts"

echo -e "${blueColour}\nAlmost there!${endColour}"
chmod +x bspwmrc sxhkdrc bspwm_resize

cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/
cp bspwm_resize ~/.config/bspwm/scripts/

echo -e "${blueColour}\nJust a little longer!${endColour}"
cd ~/.config/bspwm
sed -i 's/\r$//' bspwmrc
echo -e "${blueColour}Done!${endColour}"
cd "$back"

}

# ──── Entry point ─────────────────────────────────────────────────────────────
case $replay in
    1)
        aesthetics
        ;;
    2)
        toolsHack
        ;;
    *)
        echo -e "${redColour}\nNot a valid option, sorry! Exiting!${endColour}"
        exit 1
        ;;
esac

echo -e "${greenColour}Done!${endColour}"
