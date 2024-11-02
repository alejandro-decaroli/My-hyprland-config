#!/bin/bash

# Colores para los mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

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

# Verificar que existe el directorio packages
if [ ! -d "packages" ]; then
    print_error "No se encuentra el directorio 'packages'"
    exit 1
fi

# Verificar que existen los archivos de paquetes
if [ ! -f "packages/pacman.txt" ]; then
    print_error "No se encuentra el archivo packages/pacman.txt"
    exit 1
fi

# Instalar paquetes de pacman
print_msg "Instalando paquetes de pacman..."
while IFS= read -r package || [[ -n "$package" ]]; do
    # Ignorar líneas vacías y comentarios
    [[ -z "$package" || "$package" =~ ^# ]] && continue
    
    # Extraer el nombre del paquete (primera columna)
    package_name=$(echo "$package" | awk '{print $1}')
    
    if ! pacman -Qi "$package_name" >/dev/null 2>&1; then
        print_msg "Instalando $package_name..."
        sudo pacman -S --needed --noconfirm "$package_name" || {
            print_error "Error al instalar $package_name"
            continue
        }
    else
        print_msg "$package_name ya está instalado"
    fi
done < "packages/pacman.txt"

# Instalar yay si no está instalado
if ! command -v yay &> /dev/null; then
    print_msg "Instalando yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Verificar que existe el archivo de paquetes AUR
if [ -f "packages/yay.txt" ]; then
    print_msg "Instalando paquetes de AUR..."
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Ignorar líneas vacías y comentarios
        [[ -z "$package" || "$package" =~ ^# ]] && continue
        
        # Extraer el nombre del paquete (primera columna)
        package_name=$(echo "$package" | awk '{print $1}')
        
        if ! yay -Qi "$package_name" >/dev/null 2>&1; then
            print_msg "Instalando $package_name..."
            yay -S --needed --noconfirm "$package_name" || {
                print_error "Error al instalar $package_name"
                continue
            }
        else
            print_msg "$package_name ya está instalado"
        fi
    done < "packages/yay.txt"
else
    print_msg "No se encontró packages/yay.txt, saltando instalación de paquetes AUR"
fi

print_success "Instalación de paquetes completada!"

# Crear directorio de configuración si no existe
mkdir -p ~/.config

# Función para crear directorio si no existe
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_msg "Creando directorio $1"
    else
        print_msg "El directorio $1 ya existe"
    fi
}

# Función para crear archivo si no existe
create_file() {
    if [ ! -f "$1" ]; then
        touch "$1"
        print_msg "Creando archivo $1"
        
        # Agregar contenido inicial según el tipo de archivo
        case "$1" in
            *"/kitty/kitty.conf")
                cat > "$1" << 'EOL'
# Kitty Configuration
font_family      FiraCode Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        12.0

# Window
window_padding_width 15
confirm_os_window_close 0
background_opacity 0.85

# Cursor
cursor_shape beam
cursor_beam_thickness 1.8
EOL
            ;;
            
            *"/waybar/config")
                cat > "$1" << 'EOL'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery"],
    
    "clock": {
        "format": "{:%H:%M}",
        "tooltip-format": "{:%Y-%m-%d}"
    },
    "cpu": {
        "format": "{usage}% ",
        "tooltip": false
    },
    "memory": {
        "format": "{}% "
    }
}
EOL
            ;;
            
            *"/waybar/style.css")
                cat > "$1" << 'EOL'
* {
    border: none;
    border-radius: 0;
    font-family: "FiraCode Nerd Font";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: rgba(26, 27, 38, 0.9);
    color: #ffffff;
}

#workspaces button {
    padding: 0 5px;
    background-color: transparent;
    color: #ffffff;
}

#workspaces button.active {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
}
EOL
            ;;
            
            *"/hypr/hyprland.conf")
                cat > "$1" << 'EOL'
# Monitor
monitor=,preferred,auto,1

# Execute at launch
exec-once = waybar
exec-once = hyprpaper
exec-once = dunst
exec-once = wl-paste --watch cliphist store

# Input configuration
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = false
    }
    sensitivity = 0
}

# General window layout and colors
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee)
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

# Window decorations
decoration {
    rounding = 10
    blur = true
    blur_size = 3
    blur_passes = 1
    blur_new_optimizations = true
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
}

# Animations
animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Window rules
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(blueman-manager)$

# Key bindings
$mainMod = SUPER

bind = $mainMod, Return, exec, kitty
bind = $mainMod, Q, killactive
bind = $mainMod, M, exit
bind = $mainMod, E, exec, thunar
bind = $mainMod, V, togglefloating
bind = $mainMod, R, exec, rofi -show drun
bind = $mainMod, P, pseudo
bind = $mainMod, J, togglesplit
EOL
            ;;
            
            *"/neofetch/config.conf")
                cat > "$1" << 'EOL'
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Resolution" resolution
    info "DE" de
    info "WM" wm
    info "Terminal" term
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
    info cols
}

# Configuration
ascii_distro="arch_small"
ascii_colors=(distro)
ascii_bold="on"
EOL
            ;;
            
            *"/wlogout/config")
                cat > "$1" << 'EOL'
{
    "label" : "lock",
    "action" : "swaylock",
    "text" : "Lock",
    "keybind" : "l"
}
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Hibernate",
    "keybind" : "h"
}
{
    "label" : "logout",
    "action" : "hyprctl dispatch exit 0",
    "text" : "Logout",
    "keybind" : "e"
}
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Shutdown",
    "keybind" : "s"
}
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Suspend",
    "keybind" : "u"
}
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Reboot",
    "keybind" : "r"
}
EOL
            ;;
        esac
    else
        print_msg "El archivo $1 ya existe"
    fi
}

# [El código anterior de instalación de paquetes se mantiene igual]

# Crear directorios de configuración
print_msg "Creando directorios de configuración..."
CONFIG_DIRS=("hypr" "waybar" "kitty" "neofetch" "wlogout")
for dir in "${CONFIG_DIRS[@]}"; do
    create_dir "$HOME/.config/$dir"
done

# Crear archivos de configuración
print_msg "Creando archivos de configuración..."
create_file "$HOME/.config/kitty/kitty.conf"
create_file "$HOME/.config/waybar/config"
create_file "$HOME/.config/waybar/style.css"
create_file "$HOME/.config/hypr/hyprland.conf"
create_file "$HOME/.config/neofetch/config.conf"
create_file "$HOME/.config/wlogout/config"

print_success "Configuración base creada!"


