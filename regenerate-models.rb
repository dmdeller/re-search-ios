#!/usr/bin/env bash

command -v mogenerator >/dev/null 2>&1 || { echo >&2 "You need to install mogenerator with this command: brew install mogenerator"; exit 1; }

folder="Re-Search"
datamodeld_path="Re-Search.xcdatamodeld"
base_class="Record"

mogen_cmd="cd \"$folder\" && mogenerator -m \"./$datamodeld_path\" --base-class $base_class --template-var arc=true"
echo "$mogen_cmd"
echo
eval $mogen_cmd
