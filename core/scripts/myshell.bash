#!/bin/bash
# shellcheck disable=SC2154
# shellcheck disable=SC1090
source "$mod_colors"
#
#CORE
# commands
red
echo ">""$(cyan)Commands"
echo -e "help_mysql\thelp_git\thelp_gcloud\thelp_docker\tgenera_password\tdockrm\tcrlf_to_lf\tclear_ram"
#echo -e "\n"
echo ""
# help
red
echo ">""$(white)Help"
echo -e \
	"checks - project checks "
list=$(ls "$project_path"/modules/help)
for item in $list; do
	echo -n "help_$item "
done
#
#MODULES
# docker
echo ""
red
echo ">""$(blue)docker"
ls "$project_path"/modules/docker/
echo ""
# k8s
#
red
echo ">""$(magenta)k8s"
ls "$project_path"/modules/k8s/menus
echo ""
# ssh
red
echo ">""$(red)ssh"
ls "$project_path"/modules/ssh/
echo ""
# bw
red
echo ">""$(orange)bw - client"
echo -e "bw_push\t\tbw_clone\tbw_create"
echo ""
# john
red
echo ">""$(green)John"
echo -e "john_dictionary\tjohn_unshadow\tjohn_zip"
# utils
echo ""
red
echo ">""$(yellow)Utils"
echo -e "cert_base64_for_sealed_secret\tcheck_domains"
