actual_dir=$(pwd)
HYPR_CONFIG="$HOME/.config/hypr"
NEOFETCH_CONFIG="$HOME/.config/neofetch"
WLOGOUT_CONFIG="$HOME/.config/wlogout"
WAYBAR_CONFIG="$HOME/.config/waybar"
KITTY_CONFIG="$HOME/.config/kitty"


cp -f $WAYBAR_CONFIG/config $actual_dir/config/waybar/config 
cp -f $WAYBAR_CONFIG/style.css $actual_dir/config/waybar/style
cp -f $HYPR_CONFIG/hyprland.conf $actual_dir/config/hypr/hyprland
cp -f $KITTY_CONFIG/kitty.conf $actual_dir/config/kitty/kitty
cp -f $WLOGOUT_CONFIG/config $actual_dir/config/wlogout/config 
cp -f $NEOFETCH_CONFIG/config.conf $actual_dir/config/neofetch/config
cp -f $HOME/.bashrc $actual_dir/config/bashrc

pacman -Qe > $actual_dir/config/packages/pacman.txt
yay -Qm > $actual_dir/config/packages/yay.txt