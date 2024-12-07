#!/bin/bash

choice=$(echo -e "Hyprland.conf\nWaybar\nWlogout" | wofi --show dmenu)

case "$choice" in
    "Hyprland.conf")
        code ~/.config/hypr/hyprland.conf
        ;;
    "Waybar")
        choice=$(echo -e "Configuración\nEstilo" | wofi --show dmenu)
        case "$choice" in
            "Configuración")
                code ~/.config/waybar/config
                ;;
            "Estilo")
                code ~/.config/waybar/style.css
                ;;
        esac
        ;;
    "Wlogout")
        code ~/.config/wlogout/layout
        ;;
esac