#!/bin/bash

# Función para manejar errores
function error_exit() {
    echo "[ERROR] $1"
    exit 1
}

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo pacman -Syu --noconfirm || error_exit "No se pudo actualizar el sistema."

# Instalar el entorno gráfico básico con GTK
echo "Instalando el entorno gráfico básico con GTK..."
sudo pacman -S --noconfirm xorg-server xorg-apps xorg-xinit xorg-twm xterm gnome-settings-daemon gnome-control-center gnome-terminal || error_exit "No se pudo instalar el entorno gráfico básico con GTK."

# Instalar el gestor de sesiones SDDM
echo "Instalando SDDM..."
sudo pacman -S --noconfirm sddm || error_exit "No se pudo instalar SDDM."

# Habilitar SDDM para que se inicie al arrancar
echo "Habilitando SDDM..."
sudo systemctl enable sddm.service || error_exit "No se pudo habilitar SDDM."

# Finalizar
echo "La instalación se ha completado. Reinicia tu sistema para aplicar los cambios."
