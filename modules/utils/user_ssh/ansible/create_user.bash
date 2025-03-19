#!/bin/bash
if ! id "ansible-gcp" >/dev/null 2>&1; then
	sudo useradd -m ansible-gcp
	sudo mkdir -p /home/ansible-gcp/.ssh/
fi
