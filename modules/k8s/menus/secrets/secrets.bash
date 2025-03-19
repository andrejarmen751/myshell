#!/bin/bash
password=$($genera_password)
echo -e "Password:\n"$password" \n"
echo "Base64:"
echo "$password" | base64
password=""
