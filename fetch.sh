PROXY=
PORT=80
while [ $# -gt 0 ]
do
#	get-iplayer --proxy http://$PROXY:$PORT --get $1
	get-iplayer --aactomp3  --force --get $1
	shift
done
exit 0

