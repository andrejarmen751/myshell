#!/bin/bash
## Needs openssl, dig, awk
source "$ssl_functions"
domains_file="$project_path"/modules/utils/ssl/domains.txt
domains=$(cat $domains_file)
echo -n "" >ssl_expiration.txt
echo -n "" >not_handled.txt
for domain in $domains; do
	for_each_domain_get_date_ssl_expiration
done
ssl_expirations_file="ssl_expiration.txt"
ssl_expirations=$(cat $ssl_expirations_file)
for ssl_expiration in $ssl_expirations; do
	determine_if_expiring_soon
done
rm ssl_expiration.txt
rm not_handled.txt
