#!/bin/bash
john_unshadow() {
	hash=/tmp/"$RANDOM"
	unshadow /etc/passwd /etc/shadow >$hash
	john $hash --format=crypt --stdout | head -n10
	rm -f "$hash"
}
export john_unshadow
