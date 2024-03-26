#!/bin/bash
wget 'https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN' -O genshin.zip
unzip genshin.zip
unzip genshin_character.zip 
cd genshin_character
for filename in *; do
    decrypted=$(echo "$filename" | xxd -r -p)
    cd ..
    attributes=$(grep "$decrypted" ../list_character.csv | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    cd genshin_character
    regions=$(echo "$attributes" | cut -d ',' -f 1)
    elements=$(echo "$attributes" | cut -d ',' -f 3 | tr ',' '_')
    new_filename="${regions}_${decrypted}_${elements}"
    mv "$filename" "$regions/$new_filename.jpg"
done

cd ..

echo "JUMLAH SETIAP JENIS SENJATA"

tail -n +2 list_character.csv | awk -F ',' '{print $4}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' |  sort | uniq -c | while read -r count word; do
	echo "$word : $count"
done 

rm genshin_character.zip genshin.zip list_character.csv
