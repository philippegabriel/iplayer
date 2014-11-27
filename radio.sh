echo "Looking for >$1<"
get-iplayer --type radio | grep -i "$1" --color | grep '^[0-9]*' --color
exit 0


