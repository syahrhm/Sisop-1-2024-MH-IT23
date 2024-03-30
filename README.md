# Sisop-1-2024-MH-IT23
### SOAL 3
```sh
#!/bin/bash
wget 'https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN' -O genshin.zip
unzip genshin.zip
unzip genshin_character.zip
```
Kita perlu mendownload file zip dari link yang sudah disediakan lalu melakukan unzip terhadap file-file yang telah didownload
![image](https://github.com/v0rein/Sisop-1-2024-MH-IT23/assets/143814923/af25c7b3-57eb-46a5-829e-172e83b8749b)

```sh
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
```
Nama dari karakter-karakter yang didapat tersebut dalam kondisi ter-enkripsi dengan base64, maka dilakukan dekripsi dengan memasukkan hasil dekripsi ke variabel decrypted kemudian dilakukan rename nama ‘new file’ menjadi isi dari variabel ‘decrypted'
Setelah mendapatkan nama asli dari setiap karakter, cek file 'list_character.csv' lalu masukkan semua item dari karakter tersebut ke variabel 'attributes', 'elements', 'regions'. Pindahkan dalam folder sesuai region dengan format Nama - Region - Elemen - Senjata

![image](https://github.com/v0rein/Sisop-1-2024-MH-IT23/assets/143814923/908783da-1bc1-49af-b099-7df0b41df1e1)

```sh
cd ..

echo "JUMLAH JENIS SENJATA"

tail -n +2 list_character.csv | awk -F ',' '{print $4}' | sed 's/^[[:space:]]//;s/[[:space:]]$//' |  sort | uniq -c | while read -r count word; do
        echo "$word : $count"
done 

rm genshin_character.zip genshin.zip list_character.csv
```
Lalu, lakukan penghitungan terhadap jumlah berbagai jenis senjata yang terdapat di dalam folder lalu remove file 'list_character.csv', 'genshin_character.zip', 'genshin.zip'

![image](https://github.com/v0rein/Sisop-1-2024-MH-IT23/assets/143814923/f1a9dbfa-cba9-4a5b-9c47-7e70c546e4c7)

## search.sh
```sh
#!/bin/bash

while true; do
  waktu=$(date +"%Y%m%d%H%M%S")

  find genshin_character/ -maxdepth 2 -type f | while read -r file; do
    steghide extract -sf "$file" -p "" -xf extracted.txt
    cat extracted.txt
    decrypted_txt=$(base64 -d extracted.txt)
    echo "$decrypted_txt"
    if [[ $decrypted_txt == https* ]]; then
      wget "$decrypted_txt"
      echo "$decrypted_txt" > decrypted_url.txt
```
Lalu diperlukan script baru yaitu 'search.sh' untuk mencari clue rahasia untuk mendapatkan link gambar. Dilakukan extract dan dekripsi terhadap file-file yang terdapat di dalam 'genshin_character' dan dimasukkan link url tersebut ke dalam 'decrypted_url.txt' dan mendownload file .jpg yang terdapat dalam url tersebut
![image](https://github.com/v0rein/Sisop-1-2024-MH-IT23/assets/143814923/c786db69-cd5f-4347-8c13-895bed404e4e)

```sh
      rm extracted.txt
      echo "[$waktu] [FOUND] [$file]" >> image.log
      exit 0 
    fi
    echo "[$waktu] [NOT FOUND] [$file]" >> image.log
    rm extracted.txt
  done

  sleep 1

  if [[ $? -eq 0 ]]; then
    break
  fi
done
```
Diperlukan adanya report data ketika kita melaksanakan extract maka dibuat 'image.log' dengan format [date] [type] [image_path], lalu melakukan remove terhadap 'extracted.txt'. Lalu ketika sudah menemukan url dan sudah mendapatkan status FOUND maka script berhenti
![image](https://github.com/v0rein/Sisop-1-2024-MH-IT23/assets/143814923/313ed20b-f750-4e34-84b2-14661ea6ee10)

## REVISI
Dikarenakan adanya kesalahan format waktu dalam file 'image.log' maka diperlukan adanya sedikit perubahan dalam variabel waktu
```sh
waktu=$(date "+%y/%m/%d %H:%M:%S")
```
![image](https://github.com/v0rein/Sisop-1-2024-MH-IT23/assets/143814923/d0ef1e08-5e1b-40de-89a0-3ac2c95ac765)


