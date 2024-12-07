#!/bin/bash

# Colores para los mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

actual_dir=$(pwd)

# Función para imprimir mensajes
print_msg() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✔]${NC} $1"
}

print_error() {
    echo -e "${RED}[✘]${NC} $1"
}

# Verificar que estamos en Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "Este script solo funciona en Arch Linux"
    exit 1
fi

# Función para verificar y crear carpetas de configuración
check_config_folders() {
    # Carpetas a verificar
    HYPR_CONFIG="$HOME/.config/hypr"
    FASTFETCH_CONFIG="$HOME/.config/fastfetch"
    WLOGOUT_CONFIG="$HOME/.config/wlogout"
    WAYBAR_CONFIG="$HOME/.config/waybar"
    KITTY_CONFIG="$HOME/.config/kitty"
    ALACRITTY_CONFIG="$HOME/.config/alacritty"
    WOFI_CONFIG="$HOME/.config/wofi"
    
    echo -e "${YELLOW}Verificando carpetas de configuración...${NC}"
    
    # Verificar/crear carpeta de Hyprland
    if [ ! -d "$HYPR_CONFIG" ]; then
        echo -e "${YELLOW}Creando carpeta de configuración para Hyprland...${NC}"
        mkdir -p "$HYPR_CONFIG"
        # Crear archivo de configuración básico si no existe
        if [ ! -f "$HYPR_CONFIG/hyprland.conf" ]; then
            echo -e "${GREEN}Creando archivo de configuración básico para Hyprland...${NC}"
            touch "$HYPR_CONFIG/hyprland.conf"
        fi
    else
        echo -e "${GREEN}La carpeta de Hyprland ya existe en $HYPR_CONFIG${NC}"
    fi
    
    # Verificar/crear carpeta de Hyprland
    if [ ! -d "$WOFI_CONFIG" ]; then
        echo -e "${YELLOW}Creando carpeta de configuración para Wofi...${NC}"
        mkdir -p "$WOFI_CONFIG"
        # Crear archivo de configuración básico si no existe
        if [ ! -f "$WOFI_CONFIG/style.css" ]; then
            echo -e "${GREEN}Creando archivo de style.css para Wofi...${NC}"
            touch "$WOFI_CONFIG/style.css"
        fi
        if [ ! -f "$WOFI_CONFIG/config" ]; then
            echo -e "${GREEN}Creando archivo de config para Wofi...${NC}"
            touch "$WOFI_CONFIG/config"
        fi
    else
        echo -e "${GREEN}La carpeta de Wofi ya existe en $WOFI_CONFIG${NC}"
    fi

    # Verificar/crear carpeta de Alacritty
    if [ ! -d "$ALACRITTY_CONFIG" ]; then
        echo -e "${YELLOW}Creando carpeta de configuración para Alacritty...${NC}"
        mkdir -p "$ALACRITTY_CONFIG"
        # Crear archivo de configuración básico si no existe
        if [ ! -f "$ALACRITTY_CONFIG/alacritty.toml" ]; then
            echo -e "${GREEN}Creando archivo de configuración básico para Alacritty...${NC}"
            touch "$ALACRITTY_CONFIG/alacritty.toml"
        fi
    else
        echo -e "${GREEN}La carpeta de Alacritty ya existe en $HYPR_CONFIG${NC}"
    fi
    
    # Verificar/crear carpeta de Neofetch
    if [ ! -d "$FASTFETCH_CONFIG" ]; then
        echo -e "${YELLOW}Creando carpeta de configuración para Fastfetch...${NC}"
        mkdir -p "$FASTFETCH_CONFIG"
        # Crear archivo de configuración básico si no existe
        if [ ! -f "$FASTFETCH_CONFIG/config.jsonc" ]; then
            echo -e "${GREEN}Creando archivo de configuración básico para Fastfetch...${NC}"
            touch "$FASTFETCH_CONFIG/config.jsonc"
        fi
    else
        echo -e "${GREEN}La carpeta de Fastfetch ya existe en $FASTFETCH_CONFIG${NC}"
    fi

    if [ ! -d "$WLOGOUT_CONFIG" ]; then
        echo -e "${YELLOW}Creando carpeta de configuración para Wlogout...${NC}"
        mkdir -p "$WLOGOUT_CONFIG"
        # Crear archivo de configuración básico si no existe
        if [ ! -f "$WLOGOUT_CONFIG/config" ]; then
            echo -e "${GREEN}Creando archivo de configuración básico para Wlogout...${NC}"
            touch "$WLOGOUT_CONFIG/layout"
            touch "$WLOGOUT_CONFIG/style.css"
        fi
    else
        echo -e "${GREEN}La carpeta de Wlogout ya existe en $WLOGOUT_CONFIG${NC}"
    fi

    if [ ! -d "$WAYBAR_CONFIG" ]; then
        echo -e "${YELLOW}Creando carpeta de configuración para Waybar...${NC}"
        mkdir -p "$WAYBAR_CONFIG"
        # Crear archivo de configuración básico si no existe
        if [ ! -f "$WAYBAR_CONFIG/config" ]; then
            echo -e "${GREEN}Creando archivo de configuración básico para Waybar...${NC}"
            touch "$WAYBAR_CONFIG/config"
        fi
        if [ ! -f "$WAYBAR_CONFIG/style.css" ]; then
            echo -e "${GREEN}Creando archivo de estilo básico para Waybar...${NC}"
            touch "$WAYBAR_CONFIG/style.css"
        fi
        if [ ! -f "$WAYBAR_CONFIG/network.sh" ]; then
            echo -e "${GREEN}Creando archivo de network.sh para Waybar...${NC}"
            touch "$WAYBAR_CONFIG/network.sh"
        fi
        if [ ! -f "$WAYBAR_CONFIG/config-menu.sh" ]; then
            echo -e "${GREEN}Creando archivo de config-menu.sh para Waybar...${NC}"
            touch "$WAYBAR_CONFIG/config-menu.sh"
        fi
    else
        echo -e "${GREEN}La carpeta de Waybar ya existe en $WAYBAR_CONFIG${NC}"
    fi

    cd 

    if [ ! -f ".Xresources" ]; then
        echo -e "${YELLOW}Creando archivo de configuración básico para X...${NC}"
        touch ".Xresources"
    fi
    
    cd ..
    cd ..
    cd etc

    if [ ! -f "sddm.conf" ]; then
        echo -e "${YELLOW}Creando archivo de configuración básico para SDDM...${NC}"
        touch "sddm.conf"
    fi
    SDDM_CONFIG=$pwd
}


cd config/packages

pacman -S $(awk '{print $1}' pacman.txt)
pacman -S $(awk '{print $1}' yay.txt)

echo "Instalación completada"

cd $HOME

# Verificar carpetas antes de instalar paquetes
check_config_folders

cp -f $actual_dir/config/waybar/config $WAYBAR_CONFIG/config
cp -f $actual_dir/config/waybar/style.css $WAYBAR_CONFIG/style.css
cp -f $actual_dir/config/waybar/network.sh $WAYBAR_CONFIG/network.sh
cp -f $actual_dir/config/waybar/config-menu.sh $WAYBAR_CONFIG/config-menu.sh
cp -f $actual_dir/config/hypr/hyprland.conf $HYPR_CONFIG/hyprland.conf
cp -f $actual_dir/config/kitty/kitty.conf $KITTY_CONFIG/kitty.conf
cp -f $actual_dir/config/wlogout/config $WLOGOUT_CONFIG/config
cp -f $actual_dir/config/fastfetch/config.jsonc $FASTFETCH_CONFIG/config.jsonc
cp -f $actual_dir/config/bashrc/.bashrc $HOME/.bashrc
cp -f $actual_dir/config/sddm/sddm.conf $SDDM_CONFIG/sddm.conf

echo "Activando Docker"
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

echo "Activando Snapd"
sudo systemctl start snapd
sudo systemctl enable snapd

echo "Instalación completada, reinicie la computadora para completar la instalación"

reboot
