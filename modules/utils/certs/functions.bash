#!/bin/bash
cert_pem() {
	#Add content (\n) at the end of the line minus the last line and leave it on a single line and convert it to base64 with no spaces
	CERT_CONTENT_64=$(cat *cert.pem | sed '$!s/$/\\n/' | tr -d '\n' | sed "s/^/'/" | sed "s/$/'/" | base64 | tr -d '[:space:]')
	#Check with original file - Save into another variable to work
	CERT_CONTENT=$CERT_CONTENT_64
	#Decrypt content
	CERT_CONTENT=$(echo $CERT_CONTENT | base64 -d)
	echo $CERT_CONTENT_64
	echo ""
	echo $CERT_CONTENT
	#Delete \n found
	CERT_CONTENT=$(echo $CERT_CONTENT | sed 's/\\n/\n/g')
	#Save value into file adding break line for each space, ignoring  -----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----
	echo "$CERT_CONTENT" | sed '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/! s/ /\n/g' >temp_cert_content.txt
	#Delete new line at the end of the file
	#perl -pe 'chomp if eof' temp_cert_content.txt > temp_cert_content_no_new_line.txt
	perl -pe "s/^'|'$//g; chomp if eof" temp_cert_content.txt >temp_cert_content_no_new_line_no_quotes.txt
	#Compare the generated file with the original cert
	file_with_cert_pem=$(find . -name "*cert.pem" -type f | sed 's|^\./||')
	if [ -z "$(diff temp_cert_content_no_new_line_no_quotes.txt $file_with_cert_pem)" ]; then
		echo -e "\n"$file_with_cert_pem "equals the above output"
	fi
	rm temp_cert_content.txt
	rm temp_cert_content_no_new_line_no_quotes.txt
}
export cert_pem
key_pem() {
	#Add content (\n) at the end of the line minus the last line and leave it on a single line and convert it to base64 with no spaces
	KEY_CONTENT_64=$(cat *key.pem | sed '$!s/$/\\n/' | tr -d '\n' | sed "s/^/'/" | sed "s/$/'/" | base64 | tr -d '[:space:]')
	#Check with original file - Save into another variable to work
	KEY_CONTENT=$KEY_CONTENT_64
	#Decrypt content
	KEY_CONTENT=$(echo $KEY_CONTENT | base64 -d)
	echo $KEY_CONTENT_64
	echo ""
	echo $KEY_CONTENT
	#Delete \n found
	KEY_CONTENT=$(echo $KEY_CONTENT | sed 's/\\n/\n/g')
	#Save value into file adding break line for each space, ignoring  -----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----
	echo "$KEY_CONTENT" | sed '/-----BEGIN RSA PRIVATE KEY-----/,/-----END RSA PRIVATE KEY-----/! s/ /\n/g' >temp_key_content.txt
	#Delete new line at the end of the file
	# #perl -pe 'chomp if eof' temp_key_content.txt > temp_key_content_no_new_line.txt
	perl -pe "s/^'|'$//g; chomp if eof" temp_key_content.txt >temp_key_content_no_new_line_no_quotes.txt
	#Compare the generated file with the original cert
	file_with_key_pem=$(find . -name "*key.pem" -type f | sed 's|^\./||')
	if [ -z "$(diff temp_key_content_no_new_line_no_quotes.txt $file_with_key_pem)" ]; then
		echo -e "\n"$file_with_cert_pem "equals the above output"
	fi
	rm temp_key_content.txt
	rm temp_key_content_no_new_line_no_quotes.txt
}
export key_pem
ca_pem() {
	#Add content (\n) at the end of the line minus the last line and leave it on a single line and convert it to base64 with no spaces
	CA_CONTENT_64=$(cat *ca.pem | sed '$!s/$/\\n/' | tr -d '\n' | sed "s/^/'/" | sed "s/$/'/" | base64 | tr -d '[:space:]')
	#Check with original file - Save into another variable to work
	CA_CONTENT=$CA_CONTENT_64
	#Decrypt content
	CA_CONTENT=$(echo $CA_CONTENT | base64 -d)
	echo $CA_CONTENT_64
	echo ""
	echo $CA_CONTENT
	#Delete \n found
	CA_CONTENT=$(echo $CA_CONTENT | sed 's/\\n/\n/g')
	#Save value into file adding break line for each space, ignoring  -----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----
	echo "$CA_CONTENT" | sed '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/! s/ /\n/g' >temp_ca_content.txt
	#Delete new line at the end of the file
	# perl -pe 'chomp if eof' temp_ca_content.txt > temp_ca_content_no_new_line.txt
	perl -pe "s/^'|'$//g; chomp if eof" temp_ca_content.txt >temp_ca_content_no_new_line_no_quotes.txt
	#Compare the generated file with the original cert
	file_with_ca_pem=$(find . -name "*ca.pem" -type f | sed 's|^\./||')
	if [ -z "$(diff temp_ca_content_no_new_line_no_quotes.txt $file_with_ca_pem)" ]; then
		echo -e "\n"$file_with_cert_pem "equals the above output"
	fi
	rm temp_ca_content.txt
	rm temp_ca_content_no_new_line_no_quotes.txt
}
export ca_pem
