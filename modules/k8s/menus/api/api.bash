#!/bin/bash
script_path=$(dirname $0)
source "$script_path/functions.bash"
#Main
echo "Quin entorn vols?"
ls $k8s_env_path
read env
export env
#clear
api $1
