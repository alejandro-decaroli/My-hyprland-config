actual_dir=$(pwd)
HYPR_CONFIG="$HOME/.config/hypr"
FASTFETCH_CONFIG="$HOME/.config/fastfetch"
WLOGOUT_CONFIG="$HOME/.config/wlogout"
WAYBAR_CONFIG="$HOME/.config/waybar"
ALACRITTY_CONFIG="$HOME/.config/alacritty"
WOFI_CONFIG="$HOME/.config/wofi"


cp -f $WAYBAR_CONFIG/config $actual_dir/config/waybar/config 
cp -f $WAYBAR_CONFIG/style.css $actual_dir/config/waybar/style.css
cp -f $WAYBAR_CONFIG/network.sh $actual_dir/config/waybar/network.sh
cp -f $HYPR_CONFIG/hyprland.conf $actual_dir/config/hypr/hyprland.conf
cp -f $ALACRITTY_CONFIG/alacritty.toml $actual_dir/config/alacritty/alacritty.toml
cp -f $WLOGOUT_CONFIG/layout $actual_dir/config/wlogout/layout 
cp -f $WLOGOUT_CONFIG/style.css $actual_dir/config/wlogout/style.css 
cp -f $FASTFETCH_CONFIG/config.jsonc $actual_dir/config/fastfetch/config.jsonc
cp -f $HOME/.bashrc $actual_dir/config/bashrc
cp -f $WOFI_CONFIG/style.css $actual_dir/config/wofi/style.css
cp -f $WOFI_CONFIG/config $actual_dir/config/wofi/config

pacman -Qe > $actual_dir/config/packages/pacman.txt
yay -Qm > $actual_dir/config/packages/yay.txt

cd 
cd ..
cd ..
cd etc

cp -f sddm.conf $actual_dir/config/sddm/sddm.conf 