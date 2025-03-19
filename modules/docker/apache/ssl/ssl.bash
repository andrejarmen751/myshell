#!/bin/bash
#SSL
a2enmod ssl
cp /tmp/ssl/crt.crt /etc/ssl/
cp /tmp/ssl/key.key /etc/ssl/private/
chmod -R 755 /etc/ssl/
chown root:www-data /etc/ssl/crt.crt
chown root:www-data /etc/ssl/private/key.key
