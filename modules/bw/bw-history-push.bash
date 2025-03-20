#!/bin/bash
#set -x
bw() {
	$HOME/.config/Bitwarden\ CLI/bw "$@"
}
source "$(dirname "$0")/bw-functions.bash"
note="history"
file="$HOME/.bash_history"
clean_file

# .bash_history IF EXISTS UPLOAD CONTENT FILE TO BW
# Check if the login was successful
bw_status=$(bw sync 2>&1)
if [ "$bw_status" != "You are not logged in." ]; then
	echo "Login successful!"
	bw_sync
	note_exists=$(item_id 2>&1)
	if [ "$note_exists" != "Not found." ]; then
		note_upload_content
	else
		echo "You need to create the note"
	fi
else
	echo "You need to login in bw"
fi
