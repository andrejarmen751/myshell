#!/bin/bash
ssh="ssh -t -i ~/.ssh/stc-es ACCOUNT_NAME"
my_home="/home/ACCOUNT_NAME"
hosts_file="hosts2.txt"
hosts=$(cat $hosts_file)
for host in $hosts; do
	echo -e "Working on:  $host \n"
	#delete comviva.adm user
	$ssh@$host sudo userdel -r comviva.adm
	$ssh@$host sudo groupdel comviva
	$ssh@$host "sudo sed -i '/%comviva ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers"
done
