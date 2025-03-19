#!/bin/bash
source "$mod_colors"
clear
cyan
echo "Arch"
nocolor
yellow
echo "Pacman"
nocolor
echo "Show installed packages"
echo -e "\tpacman -Q"
echo "To search packages"
echo -e "\tpacman -Ss package_name"
echo "To install packages"
echo -e "\tpacman -S package_name"
echo "To remove packages"
echo -e "\tpacman -Rns package_name"
echo "Clean up"
echo -e "\tsudo pacman -Sc"
yellow
echo "yay - AUR"
nocolor
echo "Show installed packages"
echo -e "\tyay -Qdtq"
echo "To search packages"
echo -e "\tyay -Ss package_name"
echo "To install packages"
echo -e "\tyay -S package_name"
echo "To remove packages"
echo -e "\tyay -Rns package_name"









