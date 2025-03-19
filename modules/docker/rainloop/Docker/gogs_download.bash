#!/bin/bash
echo "Nom projecte"
github_project=gogs/gogs
echo $github_project
echo
echo
echo
echo "Tag"
tag_name=$(curl -sfL https://api.github.com/repos/gogs/gogs/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo $tag_name
echo
echo
echo
echo "Nom"
name=$(curl -sfL https://api.github.com/repos/gogs/gogs/releases/latest | grep -m1 '"name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo $name
echo
echo
echo
echo "URL"
curl -OL https://github.com/"$github_project"/releases/download/"$tag_name"/gogs_"$name"_darwin_arm64.zip
echo "curl -OL https://github.com/"$github_project"/releases/download/"$tag_name"/gogs_"$name"_darwin_arm64.zip"
#unzip gogs.zip -d htdocs/ && rm -rf gogs.zip
unzip *.zip && rm *.zip && rm gogs_download.bash
