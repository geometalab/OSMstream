#! /bin/bash

SEQ=$(curl https://overpass-api.de/api/augmented_diff_status)

MM=$[$SEQ/1000000]
KK=$[$SEQ-$MM*1000000]
KK=$[$KK/1000]
UU=$[$SEQ-$MM*1000000-$KK*1000]
A=`printf %03d $MM`
B=`printf %03d $KK`
C=`printf %03d $UU`

echo $A/$B/$C

file="/sequence.txt"
old_sequence=$(cat "$file")

if [ "$old_sequence" != "$SEQ" ]; then
    curl https://overpass-api.de/api/augmented_diff | /opt/OSMstream/producer.py
fi
