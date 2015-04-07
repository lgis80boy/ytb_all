#!/bin/bash
echo Please input the URL
read WebURL
array=(`lynx -dump $WebURL | grep http://v.youku.com/v_show/id_X | awk '{print $2}'`)
for j in ${array[*]};do
echo $j >> ./url.txt
