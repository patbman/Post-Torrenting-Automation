#!/bin/bash

Sort="$1"
music_path="/Path/to/music/folder/" #insert path to your music folder
for i in `ls -1 "$Sort"/*.mp3`

do
Title=`mp3info -p %t $i`
Artist=`mp3info -p %a $i`
Album=`mp3info -p %l $i`
filename=`mp3info -p %f $i`
filepath=`mp3info -p %F $i`

echo "$Title by $Artist from $Album"

install -D $filepath $music_path/"$Artist"/"$Album"/"$Title".mp3

done
