#!/bin/bash
wget 'https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN' -O genshin.zip
unzip genshin.zip
unzip genshin_character.zip 

cd genshin_character
ls | while read -r filename ; do
        decrypted=$(echo "$filename" | xxd -r -p)
        cd ..
        char_atr=$(grep "$decrypted" list_character.csv | sed 's/^[[:space:]]//;s/[[:space:]]$//')
        cd genshin_character
        char_atr=$(echo "$char_atr" | cut -d ',' -f 2-)
        char_elements=$(echo "$char_atr" | cut -d ',' -f 2-| tr ',' '_')
        char_regions=$(echo "$char_atr" | cut -d ',' -f 1)
        newfilename="${char_regions}_${decrypted}_${char_elements}"
        mv "$filename" "${newfilename}.jpg"
        directory="/home/ubuntu/sisop/genshin_character/$char_regions/"
        mkdir -p "$char_regions"
        mv "${newfilename}.jpg" "$char_regions/" 
done

cd ..

echo "JUMLAH JENIS SENJATA"

tail -n +2 list_character.csv | awk -F ',' '{print $4}' | sed 's/^[[:space:]]//;s/[[:space:]]$//' |  sort | uniq -c | while read -r count word; do
        echo "$word : $count"
done 

rm genshin_character.zip genshin.zip list_character.csv
