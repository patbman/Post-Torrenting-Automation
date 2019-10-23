#!/bin/bash
#shopt -s nullglob

#this script is for post torrenting processing. it transfers files from one server to another and then runs sorting scripts then sends a pushbullet notification
#this script can most likly be modified to work with a single server

pass_file="/Path/to/password/file" #path to file with ssh password
TORRENT_NAME="$1"
TORRENT_PATH="/PATH/TO/completed_downloads" #PATH to where torrent client downloaded your files
TORRENT_FULL="$TORRENT_PATH/$TORRENT_NAME"
kind="$2"
sorting_directory=/path/to/directory/for/sorting/ #a path to a directory where the files will be transfered to before being sorted into their respective folders
enddir="$sorting_directory/$TORRENT_NAME" #replace with path to directory to finally folder before sort leave $TORRENT_NAME
media_server="media_server@ip" #replace with your username and server ip
scripts=/path/to/scripts/ #a path to scripts on other server



sshpass -f $pass_file rsync -r --progress --chmod=777 "$TORRENT_PATH/$TORRENT_NAME" $media_server:$sorting_directory

wait



if [ `ls -l "$TORRENT_FULL"/*.avi 2>/dev/null | wc -l`  != 0 ] || [ `ls -l "$TORRENT_FULL"/*.mp4 2>/dev/null | wc -l` != 0 ] || [ `ls -l "$TORRENT_FULL"/*.mkv 2>/dev/null | wc -l` != 0 ]; then

	sshpass -f $pass_file ssh $media_server $scripts/organization.sh "'$TORRENT_NAME'"

elif [ `ls -l "$TORRENT_FULL"/*.mp3 2> /dev/null | wc -l` != 0 ] || [ `ls -l "$TORRENT_FULL"/*.flac 2>/dev/null | wc -l` != 0 ]; then

	sshpass -f $pass_file ssh $media_server $scripts/music.sh "'$enddir'"
	python $scripts/plexrefresh.py
	music="y"
elif [ `ls -l "$TORRENT_FULL"/*.r* 2>/dev/null | wc -l`  != 0 ]; then

	sshpass -f $pass_file ssh $media_server $scripts/rarsort.sh "'$enddir'"
	wait
	sshpass -f $pass_file ssh $media_server $scripts/organization.sh "'$TORRENT_NAME'"



else

	:

fi



# Pushbullet variables
API_KEY='PUSHBULLET KEY REDACTED' #insert you API key here
API_URL="https://api.pushbullet.com/api"
IDENS=$(curl -s "${API_URL}/devices" -u ${API_KEY}: | tr '{' '\n' | tr ',' '\n' | grep iden | cut -d'"' -f4)
# Simplified version by Yaron Shahrabani in comment
IDENS=$(curl -s "${API_URL}/devices" -u ${API_KEY}: | tr '[{,]' '\n' | awk -F\" '/iden/ {print $4}')
DEVICE_ID=$(echo "${IDENS}" | sed -n 'p')
#-------------------------------------------------#

# Error check
checkCurlOutput() {
res=$(echo "$1" | grep -o "created" | tail -n1)
if [[ "$res" != "created" ]]; then
    echo "Error submitting the request. The POST error message was:"
fi
echo $res
}


# Push the stuff to Pushbullet
CURL=$(curl -s "${API_URL}/pushes" -u $API_KEY: -d device_iden=${DEVICE_ID} -d type=note -d title="$TORRENT_NAME finished processing")

#checkCurlOutput "${CURL}"