#!/bin/bash
# Get latest CLI version
version=$(curl -s https://api.github.com/repos/bitwarden/clients/releases | jq -r '.[] | select(.name | test("CLI")) | .tag_name' | head -n 1)
# Download latest CLI version
mkdir -p "$HOME/.config/Bitwarden CLI"
curl -s https://api.github.com/repos/bitwarden/clients/releases | jq -r '.[] | select(.name | test("CLI")) | .assets[] | select(.name | contains("linux")) | .browser_download_url' | head -n 1 | xargs -I {} curl -L -o "$HOME/.config/Bitwarden CLI"/bw-$version.zip {}
# Extract content
unzip "$HOME/.config/Bitwarden CLI"/bw-$version.zip -d "$HOME/.config/Bitwarden CLI"/
rm "$HOME/.config/Bitwarden CLI"/bw-$version.zip
chmod +x "$HOME/.config/Bitwarden CLI"/bw
