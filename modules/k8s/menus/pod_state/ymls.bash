#!/bin/bash
script_path=$(dirname $0)
source ""$script_path"/functions.bash"
#Main
echo "Quin entorn vols?"
ls $k8s_env_path
read env
export env
#clear
echo "Quina app vols?"
ls "$k8s_env_path"/"$env"/
echo ""
echo $app
read app
clear
echo "Aquests son els yaml's d'aquesta app"
ls "$k8s_env_path"/"$env"/"$app"/
echo ""
echo "Accions a realitzar"
echo "apply/delete/atura"
read accio
case $accio in
apply)
	aplica_yml
	;;
delete)
	elimina_yml
	;;
atura)
	atura_yml
	;;
esac
