#!/bin/sh
echo -ne '\033c\033]0;GameJam_6.8.2024\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/kemical_pen3.x86_64" "$@"
