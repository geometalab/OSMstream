#! /bin/bash

SEQ=$(curl https://overpass-api.de/api/augmented_diff_status)
file="/sequence.txt"
old_sequence=$(cat "$file")

if [ "$old_sequence" != "$SEQ" ]; then
    curl https://overpass-api.de/api/augmented_diff?id=$SEQ  | /opt/OSMstream/producer.py
    echo $SEQ > $file
fi
