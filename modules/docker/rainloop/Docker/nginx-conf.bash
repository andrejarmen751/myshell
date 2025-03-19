#!/bin/bash
cat >/etc/nginx/sites-available/default <<EOF
server {
  listen          80;
  server_name     ${HOSTNAME};
  location / {
    proxy_pass      http://localhost:6000;
  }
}
EOF
service nginx restart
