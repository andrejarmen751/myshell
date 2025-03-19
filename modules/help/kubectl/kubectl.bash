#!/bin/bash
source "$mod_colors"
clear
cyan
echo "Kubectl"
nocolor
yellow
echo "Context"
nocolor
echo -e "\tkubectl config current-context"
echo -e "\tkubectl config get-contexts"
echo -e "\tkubectl config use-context context-name"
