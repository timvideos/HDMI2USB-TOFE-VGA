#!/bin/bash

NEW_NAME="TOFE-$1"
BOARD_STYLE=$2

if [ -z $1 -o -z $2 ]; then
	echo "Usage rename-board.sh 'your board name' (full|half)"
	exit 1
fi

case $BOARD_STYLE in
	full)
		;;
	half)
		;;
	*)
		echo "Style must be either:"
		echo " - 'full' for a full height board"
		echo " - 'half' for a half height board"
		exit 1
esac

set -x
set -e

OLD_NAME="TOFE-Expansion-Board"

case $BOARD_STYLE in
	full)
		git mv board/TOFE-Expansion-Board-Full-Height.kicad_pcb "board/${OLD_NAME}.kicad_pcb"
		git rm board/TOFE-Expansion-Board-Half-Height.kicad_pcb
		;;
	half)
		git mv board/TOFE-Expansion-Board-Half-Height.kicad_pcb "board/${OLD_NAME}.kicad_pcb"
		git rm board/TOFE-Expansion-Board-Full-Height.kicad_pcb
		;;
esac

# Rename everything.
for F in board/$OLD_NAME*; do
	NEW_F="$(echo $F | sed -es/${OLD_NAME}/${NEW_NAME}/)"

	git mv "$F" "$NEW_F"
	sed -i \
	 -e"s/${OLD_NAME}/${NEW_NAME}/g" \
	 -e"s/TOFE Expansion Board/$(echo ${NEW_NAME} | sed -e's/-/ /') Expansion Board/g" \
	 -e"s/TOFE_Expansion_Board/$(echo ${NEW_NAME} | sed -e's/-/_/')_Expansion_Board/g" \
	 "$NEW_F"
	git add "$NEW_F"
done

# Remove the rename-script.
git rm rename-board.sh

git commit -am "Creating ${NEW_NAME}!"

set +x
set +e
echo
echo "Use 'git reset --hard HEAD~1' to undo the rename."
echo
