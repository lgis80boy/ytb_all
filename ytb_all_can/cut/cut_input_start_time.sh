#!/bin/bash
echo "<Please input the start time like 00:10:00>"
read start_time
#	check "video path"
if [ -e "./video" ]
	then
	echo "video path has made"
	else
    mkdir video
fi
#	check "cut path"
if [ -e "./cut" ]
	then
	echo "cut path has made"
	else
    mkdir cut
fi
#	start cutting
cd ./video
array_cut=(`ls -l | grep ^- | awk '{print $9}'`)
	for i in ${array_cut[*]};do
		ffmpeg -ss $start_time -t 10:00:00 -i $i -vcodec copy -acodec copy ../cut/$i
		echo "<cutting is done>"
	done
cd ..
