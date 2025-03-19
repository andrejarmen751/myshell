#!/bin/bash
ssh="ssh -t -i ~/.ssh/stc-es ACCOUNT_NAME"
my_home="/home/ACCOUNT_NAME"
hosts_file="hosts.txt"
hosts=$(cat $hosts_file)
for host in $hosts; do
	echo -e "Working on:  $host \n"
	$ssh@$host 'bash -s' <ansible/create_user.bash
	scp -i ~/.ssh/stc-es ansible/authorized_keys ACCOUNT_NAME@$host:~
	scp -i ~/.ssh/stc-es ansible/ansible ACCOUNT_NAME@$host:~
	#SSH ansible
	$ssh@$host sudo mv $my_home/authorized_keys /home/ansible-gcp/.ssh/authorized_keys
	$ssh@$host sudo chown ansible-gcp:ansible-gcp /home/ansible-gcp/.ssh/authorized_keys
	$ssh@$host sudo chmod 700 /home/ansible-gcp/.ssh/authorized_keys
	#sudo ansible
	$ssh@$host sudo mv $my_home/ansible /etc/sudoers.d/ansible
	$ssh@$host sudo chown root:root /etc/sudoers.d/ansible
	$ssh@$host sudo chmod 440 /etc/sudoers.d/ansible
	#Timezone
	#$ssh@$host sudo timedatectl set-timezone Europe/Madrid
	#Update/upgrade
	# $ssh@$host sudo yum update -y
	# $ssh@$host sudo yum upgrade -y
	# $ssh@$host sudo yum install nano -y
done
