#!/bin/bash
source "$mod_colors"
clear
cyan
echo "Git"
nocolor
yellow
echo "Create new branch"
nocolor
echo "git create branch"
yellow
echo "Push local branch to origin"
nocolor
echo "git push -u origin feature-branch"
yellow
echo "Delete remote branch"
nocolor
echo "git push origin --delete feature-branch"
yellow
echo "Delete local branch"
nocolor
echo "git branch -d branch-name"
yellow
echo "Update .git index for local and remote branches "
nocolor
echo "git fetch -p - refresh remote branch "
yellow
echo "Commit logs"
nocolor
echo 'git log -n 10 --pretty=format:"%an <%ae> - %s" --follow README.md'
yellow
echo "Keeping the Changes (Soft Reset)"
nocolor
echo "git reset --soft HEAD~1"
yellow
echo "Discarding the Changes (Hard Reset)"
nocolor
echo "git reset --hard HEAD~1"
yellow
echo "Config for Github - add to .custom_profile"
nocolor
#echo "eval `ssh-agent -s`"
echo "eval \$(ssh-agent -s)"
echo "ssh-add ~/.ssh/private-key"
echo "ssh-add -l -E sha256"
yellow
echo "Change passphrase for ssh key"
nocolor
ssh-keygen -p -f ~/.ssh/id_rsa
yellow
echo "To change colors"
nocolor
echo 'git config --global color.branch.current "green"'
echo 'git config --global color.branch.remote "cyan"'
echo 'git config --global color.branch.local "yellow"'
cyan
echo "GitHub - gh"
nocolor
echo "gh auth login"
nocolor
echo "pull_request - alias"
nocolor
