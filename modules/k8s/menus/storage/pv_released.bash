#!/bin/bash
script_path=$(dirname $0)
source ""$script_path"/functions_pv.bash"
#Main
echo "Quin entorn vols?"
ls $k8s_env_path
read env
export env
clear
pv_released
