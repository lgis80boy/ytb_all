#!/bin/bash

if [ -e "./video" ];
then
	rm -fr ./video
	echo "video path deleted !"
	mkdir -p video
	echo "video path has made !"
else
	mkdir -p video
	echo "Can't find video path and make it !"
fi

if [ -e "./join" ];
then
	echo "join path has made !"
else
	mkdir -p join
	echo "Can't find join path and make it !"
fi

if [ -e "meta.html" ];
then
	rm -f meta.html
	echo "meta.html has made !"
	echo "meta.html deleted !"
fi

if [ -e "meta1.txt" ];
then
	rm -f meta1.txt
	echo "meta1.txt has made !"
	echo "meta1.txt deleted !"
fi

if [ -e "meta2.txt" ];
then
	rm -f meta2.txt
	echo "meta2.txt has made !"
	echo "meta2.txt deleted !"
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

#	download the file
output_name=`grep '<input type="hidden" name="filename" value="' ./meta1.txt | sed 's/^.*<input type="hidden" name="filename" value="//g' | sed 's/"\/>.*$//g' | sed 's/ /_/g'`
echo "Downloading $output_name"

array_meta2=(`cat ./meta2.txt`)
	for m in ${array_meta2[*]};do
		wget "$m" -U mozilla -O "./video/`echo $m|cut -c 64-65`.flv"
	done

#	join the file

array_join=(`ls ./video`)
	cd ./video 
	python3.4 ../join_flv.py --output ../join/$output_name.flv `echo ${array_join[*]}`		
	if [ -e "../join/$output_name.flv" ];
	then 		
		echo " $output_name.flv is ok !"
	else
		echo " $output_name.flv is filed !"
	fi
	cd ..
