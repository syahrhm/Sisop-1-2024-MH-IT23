#!/bin/bash
wget 'https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN' -O genshin.zip
unzip genshin.zip
unzip genshin_character.zip 
cd genshin_character
ls | while read -r filename ; do
	decrypted=$(echo "$filename" | xxd -r -p)
	cd ..
	attributes=$(grep "$decrypted" list_character.csv | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
	cd genshin_character
	attributes=$(echo "$attributes" | cut -d ',' -f 2-)
	elements=$(echo "$attributes" | cut -d ',' -f 2-| tr ',' '_')
	regions=$(echo "$attributes" | cut -d ',' -f 1)
	new_filename="${regions}_${decrypted}_${elements}"
	mv "$filename" "$new_filename.jpg"
	directory="/home/ubuntu/sisop/genshin_character/$regions/"
	mkdir -p "$regions"
	mv "$new_filename.jpg" "$regions/" 
done

cd ..

echo "JUMLAH SETIAP JENIS SENJATA"

tail -n +2 list_character.csv | awk -F ',' '{print $4}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' |  sort | uniq -c | while read -r count word; do
	echo "$word : $count"
done 

rm genshin_character.zip genshin.zip list_character.csv
