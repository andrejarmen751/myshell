#!/bin/bash
item_id() {
	bw get item "$note" | jq -r '.id'
}

bw_sync() {
	bw sync &>/dev/null
}

note_upload_content() {
	# Step 1: Retrieve the item
	item_id=$(bw get item $note | jq -r '.id')
	item_data=$(bw get item $item_id)
	# Step 2: Concatenate command history
	content=$(paste -sd '\n' $file)
	# Step 3: Update the notes field
	updated_item=$(echo "$item_data" | jq --arg content "$content" '.notes = $content')
	# Step 4: Update the item in Bitwarden
	echo "$updated_item" | bw encode | bw edit item $item_id
	commands=$(echo "$updated_item" | jq -r '.notes | split("\n") | .[]')
	# Step 5: Update the item in Bitwarden
	echo "$updated_item" | bw encode | bw edit item $item_id >/dev/null 2>&1
	# echo "$commands"
}

note_download_content() {
	# Step 1: Retrieve the item
	item_id=$(bw get item $note | jq -r '.id')
	item_data=$(bw get item $item_id)
	# Step 2: Extract the notes content
	content=$(echo "$item_data" | jq -r '.notes')
	# Step 3: Append the content to .bash_history
	echo "$content" >>$file
}

note_delete() {
	bw delete item $note_exists
	bw_sync
}
# Use a Subset of History: If the entire history is too large, consider only sending a subset of the commands. For example, you could limit it to the last 100 commands:

# content=$(tail -n 100 $file | paste -sd '\n')
