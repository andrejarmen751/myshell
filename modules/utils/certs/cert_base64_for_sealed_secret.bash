#!/bin/bash
# This should be executed on a directory that contains filenames with 'ca.pem', 'cert.pem' and 'key.pem'
source "$certs_functions"
for filename in *; do
	if [[ $filename == *"cert.pem"* ]]; then
		echo ""
		echo "File $filename"
		echo ""
		cert_pem
		echo ""
	elif [[ $filename == *"key.pem"* ]]; then
		echo "File $filename"
		echo ""
		key_pem
		echo ""
	elif [[ $filename == *"ca.pem"* ]]; then
		echo "File $filename"
		echo ""
		ca_pem
	fi
done
