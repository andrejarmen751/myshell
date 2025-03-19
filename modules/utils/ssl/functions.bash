#!/bin/bash
for_each_domain_get_date_ssl_expiration() {
	if output_not_empty=$(dig @1.1.1.1 $domain +short); then
		#If not empty
		if [ -n "$output_not_empty" ]; then
			# Script to get SSL certificate expiration, force timeout to end command
			expiration_raw=$(timeout 2 openssl s_client -connect $domain:443 -servername $domain 2>/dev/null | grep -v "Warning:" | openssl x509 -enddate -noout)
			# Clear output
			expiration_time=$(echo "$expiration_raw" | sed -e 's/notAfter=//' -e 's/ GMT//')
			# Set format to dd/mm/yy
			format_date=$(date -d "$expiration_time" +"%Y/%m/%d")
			# Save domain and expiration date to file
			echo $domain,$format_date >>ssl_expiration.txt
		else
			# Save empty ones into another file
			echo $domain - Not checked >>not_handled.txt
		fi
	fi
}
export for_each_domain_get_date_ssl_expiration

determine_if_expiring_soon() {
	# Separate values domain and date into separate vars
	domain_name=$(echo "$ssl_expiration" | awk -F',' '{split($0, parts, ","); print parts[1]}')
	expiration_time=$(echo "$ssl_expiration" | awk -F',' '{split($0, parts, ","); print parts[2]}')
	#Calculate days remaining until expiration_time
	target_date="$expiration_time"
	target_epoch=$(date -d "$target_date" +%s)
	current_epoch=$(date +%s)
	remaining_days=$(((target_epoch - current_epoch) / 86400))
	# If less than 20 to expipe, send email, if not, it's ok
	if [ "$remaining_days" -lt "20" ]; then
		echo "Domain: $domain_name expiration time $expiration_time remaining days: $remaining_days - send email"
	else
		echo "Domain: $domain_name expiration time $expiration_time remaining days: $remaining_days - ok, don't send email"
	fi
}
export determine_if_expiring_soon
