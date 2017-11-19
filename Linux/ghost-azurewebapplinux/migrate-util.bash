#!/bin/bash
[ -e "/home/site/wwwroot/hostingstart.html" ] && rm "/home/site/wwwroot/hostingstart.html"
echo "************started migration***********"
# move content if it doesn't exist
if ! [ "$(ls -A $GHOST_CONTENT)" ]; then
	baseDir="$GHOST_INSTALL/content.orig"
	for src in "$baseDir"/*/ "$baseDir"/themes/*; do
		src="${src%/}"
		target="$GHOST_CONTENT/${src#$baseDir/}"
		mkdir -v -p "$(dirname "$target")"
		if [ ! -e "$target" ]; then
			# Added the -h option in order to follow symlinks
			# Azure persistent storage is a CIFS share that is not able to store symlinks
			tar -hcC "$(dirname "$src")" "$(basename "$src")" | tar -xC "$(dirname "$target")"
		fi
	done
	gosu node knex-migrator-migrate --init --mgpath "$GHOST_INSTALL/current"
fi
echo "************migration ended***********"
[ -e "/home/site/config.production.json" ] && cp "/home/site/config.production.json" "/var/lib/ghost/config.production.json"
