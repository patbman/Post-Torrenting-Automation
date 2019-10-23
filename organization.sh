#!/bin/bash

sort="$1"

$content="/path/to/finished/content" #insert path to where you want the media to go after it has been sorted


filebot -script fn:amc --output "#content" --log-file amc.log -get-subtitles --action copy -non-strict "/media/root/Disk_3/My_Files/Media/To_Be_Sorted/$sort" --def plex=10.0.0.193:"3tFRse8hG2SWWDMoKQxz" clean=y artwork=y
#echo $?
#if [ $? -eq 0 ]
#then
#	rm -rf "/media/root/Disk_3/My_Files/Media/To_Be_Sorted/$sort"
#elif [ $? -eq 1 ]
#then
#	bash "/home/pat/pushbullet_failure.sh $sort"
#fi
