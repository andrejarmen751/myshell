#!/bin/bash
rm -rf index.html
curl -LOf https://www.rainloop.net/repository/webmail/rainloop-latest.zip
unzip *.zip && rm *.zip
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chown -R www-data:www-data .
