#!/bin/bash
rm -r -f /etc/apache2/sites-enabled/000-default.conf
cp -r /tmp/ssl/000-default.conf /etc/apache2/sites-enabled/
dos2unix /etc/apache2/sites-enabled/000-default.conf
cp -r /tmp/servername/default-ssl.conf /etc/apache2/sites-enabled/
dos2unix /etc/apache2/sites-enabled/default-ssl.conf
