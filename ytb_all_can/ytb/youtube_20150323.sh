#!/bin/bash

# find . -type f -print0 | while read -d $'\0' file; do mv "$file" "$(echo $file | sed 's/ /_/g')";done

webURL=webURL.txt
keyfile=./keyfile.txt
# 2 Username
# 4 Password
# 6 Discription
# 8 Keywords
# 10 FileHead
# 12 FileFoot
Username=`head -2 ./keyfile.txt | tail -1`
Password=`head -4 ./keyfile.txt | tail -1`
Discription=`head -6 ./keyfile.txt | tail -1`
Keywords=`head -8 ./keyfile.txt | tail -1`
FileHead=`head -10 ./keyfile.txt | tail -1`
FileFoot=`head -12 ./keyfile.txt | tail -1`
videoDIR=./video

function YTB_makefile(){
	echo "Please input username and press enter"
}

function YTB_Download_Nohup(){
        echo "Download all url to video DIR !";
                if [ -e "./video" ]
                then
                echo "video DIR is made"
                else
                mkdir video
                fi
        cd $videoDIR
        array_download=(`cat ../webURL.txt`)
                for i in ${array_download[*]};do
                        nohup you-get $i &
                        echo "$i DownLoad is OK" >> ../log/download_log.txt
                done
        cd ..
}

function YTB_Download(){
	echo "Download all url to video DIR !";
		if [ -e "./video" ]
		then
		echo "video DIR is made"
		else
		mkdir video
		fi	
	cd $videoDIR
	array_download=(`cat ../webURL.txt`)
		for i in ${array_download[*]};do
			you-get $i
			echo "$i DownLoad is OK" >> ../log/download_log.txt
		done
	cd ..
}

function YTB_Upload_Delete(){
	echo "Upload all files to youtube and delete file!"
	cd $videoDIR
	# no KongGe
		find . -type f -print0 | while read -d $'\0' file; do mv "$file" "$(echo $file | sed 's/ /_/g')";done
		array_upload=(`ls -l | grep ^- | awk '{print $9}'`)
			for j in ${array_upload[*]};do
				youtube-upload --email="$Username" --password="$Password" --title="$FileHead`echo $j | cut -d . -f 1`$FileFoot" --description="$Discription" --category="Film" --keywords="$Keywords" ./$j && rm -f $j && echo "$j---->upload OK" >> ../log/upload_log.txt
			done
	cd ..
}

function YTB_Upload_NoDelete(){
	echo "Upload all files to youtube and don't delete file!"
	cd $videoDIR
	# no KongGe
		find . -type f -print0 | while read -d $'\0' file; do mv "$file" "$(echo $file | sed 's/ /_/g')";done
		array_upload=(`ls -l | grep ^- | awk '{print $9}'`)
			for j in ${array_upload[*]};do
				youtube-upload --email="$Username" --password="$Password" --title="$FileHead`echo $j | cut -d . -f 1`$FileFoot" --description="$Discription" --category="Film" --keywords="$Keywords" ./$j && echo "$j---->upload OK" >> ../log/upload_log.txt
			done
	cd ..
}

function YTB_Upload_SuiJi_Delete(){
	echo "Upload all files to youtube with SuiJi name and delete file!"
	cd $videoDIR
	# no KongGe
		find . -type f -print0 | while read -d $'\0' file; do mv "$file" "$(echo $file | sed 's/ /_/g')";done
		array_upload=(`ls -l | grep ^- | awk '{print $9}'`)
			for j in ${array_upload[*]};do
				youtube-upload --email="$Username" --password="$Password" --title="`echo `date +%N``_`echo $j | cut -d . -f 1`" --description="`echo `date +%N``" --category="Film" --keywords="`echo `date +%N``" ./$j && rm -f $j && echo "$j---->upload OK" >> ../log/upload_log.txt
			done
	cd ..
}

function YTB_Upload_SuiJi_NoDelete(){
	echo "Upload all files to youtube with SuiJi name and don't delete file!"
	cd $videoDIR
	# no KongGe
		find . -type f -print0 | while read -d $'\0' file; do mv "$file" "$(echo $file | sed 's/ /_/g')";done
		array_upload=(`ls -l | grep ^- | awk '{print $9}'`)
			for j in ${array_upload[*]};do
				suiji_name=`date +%N`
				youtube-upload --email="$Username" --password="$Password" --title="`echo $suiji_name`_`echo $j | cut -d . -f 1`" --description="`echo $suiji_name`" --category="Film" --keywords="`echo $suiji_name`" ./$j && echo "$j---->upload OK" >> ../log/upload_log.txt
			done
	cd ..
}

function YTB_All_Delete(){
	echo "Download + Upload + Delete files !"
	echo "1 - Download all url to video DIR !";
	# download
		if [ -e "./video" ]
		then
		echo "video DIR is made"
		else
		mkdir video
		fi	
	cd $videoDIR
		array_download=(`cat ../webURL.txt`)
			for i in ${array_download[*]};do
				you-get $i
				echo "$i DownLoad is OK" >> ../log/download_log.txt
			done
	cd ..

	# upload delete
	cd $videoDIR
		find . -type f -print0 | while read -d $'\0' file; do mv "$file" "$(echo $file | sed 's/ /_/g')";done
		array_upload=(`ls -l | grep ^- | awk '{print $9}'`)
			for j in ${array_upload[*]};do
				youtube-upload --email="$Username" --password="$Password" --title="$FileHead`echo $j | cut -d . -f 1`$FileFoot" --description="$Discription" --category="Film" --keywords="$Keywords" ./$j && rm -f $j && echo "$j---->upload OK" >> ../log/upload_log.txt
			done
	cd ..
}

function YTB_All_No_Delete(){
	echo "Download + Upload + don't delete files !"
	echo "1 - Download all url to video DIR !";
	# download
		if [ -e "./video" ]
		then
		echo "video DIR is made"
		else
		mkdir video
		fi
	cd $videoDIR
		array_download=(`cat ../webURL.txt`)
			for i in ${array_download[*]};do
				you-get $i
				echo "$i DownLoad is OK" >> ../log/download_log.txt
			done
	cd ..

	# upload don't delete files
	cd $videoDIR
		find . -type f -print0 | while read -d $'\0' file; do mv "$file" "$(echo $file | sed 's/ /_/g')";done
		array_upload=(`ls -l | grep ^- | awk '{print $9}'`)
			for j in ${array_upload[*]};do
				youtube-upload --email="$Username" --password="$Password" --title="$FileHead`echo $j | cut -d . -f 1`$FileFoot" --description="$Discription" --category="Film" --keywords="$Keywords" ./$j && echo "$j---->upload OK" >> ../log/upload_log.txt
			done
	cd ..
}
echo "==========================================================="
echo -e "|\033[40;36m which do you want  ? inpute the number.\033[0m                 |"
echo "| 1 Download                                              |"
echo "| 2 Download & nohup                                      |"
echo "| 3 Upload and delete file                                |"
echo "| 4 Upload and don't delete file                          |"
echo "| 5 Upload random name and delete file                    |"
echo "| 6 Upload random name and don't delete file              |"
echo "| 7 Download and upload and delete file                   |"
echo "| 8 Download and upload and don't delete file             |"
echo "|***************** Produce by Eric Liang *****************|"
echo "|******************* www.lianggang.in ********************|"
echo "==========================================================="
read num

case "$num" in
	[1] ) (YTB_Download);;
	[2] ) (YTB_Download_Nohup);;
	[3] ) (YTB_Upload_Delete);;
	[4] ) (YTB_Upload_NoDelete);;
	[5] ) (YTB_Upload_SuiJi_Delete);;
	[6] ) (YTB_Upload_SuiJi_NoDelete);;
	[7] ) (YTB_All_Delete);;
	[8] ) (YTB_All_No_Delete);;
	*) echo "Input wrong exit !";;
esac
