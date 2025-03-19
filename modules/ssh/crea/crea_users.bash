#!/bin/bash
#NOTE: before run script you need .pub files under path!!!!
if [ -e "$HOME"users_ssh.txt ]; then
	#Inicialitzem variable file amb users.txt
	#I variable users amb el contingut del .txt
	path_pub_file="$HOME"
	file=""$HOME"users_ssh.txt"
	users=$(cat $file)
	#Iniciem bucle per recorrer contingut file entrada per entrada
	for username in $users; do
		sudo useradd -m -s /bin/bash -G sudo "$username"
		sudo mkdir /home/"$username"/.ssh
		sudo mv "$path_pub_file""$username".pub /home/"$username"/.ssh/authorized_keys
		sudo chown "$username":"$username" /home/"$username"/.ssh/authorized_keys
	done
	rm -rf "$path_pub_file"*".pub"
else
	echo "File not found: "$HOME"users_ssh.txt"
fi
