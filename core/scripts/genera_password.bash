#!/bin/bash
set -e
#if not parameter..
if [ -z "$1" ]; then
# shellcheck disable=SC2154
	password=$($genera_password)
else
	password="$1"
fi
echo -e "Password:
$password 
"
echo "Base64:"
echo -e "$(echo -n "$password" | base64)"
echo ""
echo "Md5:"
echo -e "$(echo -n "$password" | openssl md5 | awk '{ printf $2 }')"
echo ""
echo "Sha1:"
echo -e "$(echo -n "$password" | openssl sha1 | awk '{ printf $2 }')"
echo ""
echo "Sha256:"
echo -e "$(echo -n "$password" | openssl sha256 | awk '{ printf $2 }')"
password=""
