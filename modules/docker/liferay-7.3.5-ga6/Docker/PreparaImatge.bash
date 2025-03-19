#!/bin/bash
#!/bin/sh
#Bàsic sistema
apk update &&
	apk upgrade -q &&
	apk add openssl tzdata curl wget zip tree dos2unix -q &&
	cp -r -f /usr/share/zoneinfo/Europe/Madrid /etc/localtime
#SSL liferay
#openssl req \
#  -new \
#  -newkey rsa:4096 \
#  -days 3650 \
#  -nodes \
#  -x509 \
#  -subj "/C=EU/ST=CA/L=CPD/O=BcnAct/CN=localhost" \
#  -keyout /tmp/localhost-rsa-key.pem \
#  -out /tmp/localhost-rsa-cert.pem && chown liferay:liferay /tmp/*.pem
