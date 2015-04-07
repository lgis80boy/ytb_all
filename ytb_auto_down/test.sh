#!/bin/bash

if [ -e "./video" ];
then
	rm -fr ./video
	mkdir -p video
	echo "video path has made !"
else
	mkdir -p video
fi

if [ -e "./join" ];
then
	echo "join path has made !"
else
	mkdir -p join
fi

if [ -e "meta.html" ];
then
	rm -f meta.html
	echo "meta.html has made !"
	echo "meta.html has deleted !"
fi

if [ -e "meta1.txt" ];
then
	rm -f meta1.txt
	echo "meta1.txt has made !"
	echo "meta1.txt has deleted !"
fi

if [ -e "meta2.txt" ];
then
	rm -f meta2.txt
	echo "meta2.txt has made !"
	echo "meta2.txt has deleted !"
fi

echo "please input URL!"
read URL
ue=$(php -r "echo urlencode('$URL');")
parser="http://www.flvcd.com/parse.php?kw=$ue&flag=one&format=super"

#	touch meta.html
if ! wget $parser -U mozilla -O meta.html; then
	echo " Unable to touch the parser, check network status for the shell ！"
fi

#	gbk to utf-8
iconv -f gbk -t utf-8 meta.html >> meta1.txt

#	seach download link 
grep '<input type="hidden" name="inf" value="' ./meta1.txt | sed 's/^.*<input type="hidden" name="inf" value="//g' | sed 's/".*$//g' | sed 's/|/\
/g' | sed '$d' >> meta2.txt

#	seach #EXTM3U and delete it
headline=`head -1 ./meta2.txt | tail -1`
if [ "$headline"="#EXTM3U" ];then
	echo "meta2.txt has #EXTM3U"
	sed '1d' ./meta2.txt >> meta3.txt
else
	echo "meta2.txt doesn't have #EXTM3U "
	mv meta2.txt meta3.txt
fi

#	download the file
a_number=1
array_meta3=(`cat ./meta3.txt`)
	for m in ${array_meta3[*]};do
#		ffmpeg -i "$m" -c copy -bsf:a aac_adtstoasc ./$a.mp4
		wget "$m" -U mozilla -O "./video/$a_number.flv"
		((a_number=a_number+1))
	done

#	join the file
array_join=(`ls -t ./video`)
	cd ./video 
	python3.4 ../join_flv.py --output ../join/joined.flv `echo ${array_join[*]}`		
	if [ -e "../join/joined.flv" ];
	then 		
		echo "join the files is ok"
	else
		echo "join the files is filed"
	fi
	cd ..

#	clear the buffer file
rm -f meta.html
rm -f meta1.txt
rm -f meta2.txt
rm -f meta3.txt
echo "download is ok !"