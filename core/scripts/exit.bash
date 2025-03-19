#!/bin/bash
sed -i '/^\s*#/d' "$HISTFILE"
sed -i '/^$/d' "$HISTFILE"
awk '!seen[$0]++' "$HISTFILE" >temp && mv temp "$HISTFILE"
