#!/bin/bash
#client
echo -e "Requirements: user on remote and ssh access, dns\n"
echo -e "Insert a name to identify remote host:\n"
read remote
ssh-keygen -f ~/.ssh/$remote -t rsa -b 4096
chmod o-rwx ~/.ssh/$remote
ssh-copy-id $USER@$remote
