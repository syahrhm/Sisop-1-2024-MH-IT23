# Sisop-1-2024-MH-IT23
### SOAL 1
a. Tampilkan nama pembeli dengan total sales paling tinggi <br />
 	`awk -F ',' 'NR == 1 { next } { if ($17 > tertinggi) { tertinggi = $17; cust = $6 } } END { print cust }' Sandbox.csv` <br />
 	command ini melangkahi baris header dengan NR == 1 {next} dan membandingkan nilai sales di kolom 17 berdasarkan nama customer di kolom 6. <br /> <br />
b. Tampilkan customer segment yang memiliki profit paling kecil <br />
	`profitMin=$(awk -F ',' 'NR > 1 { segment[$14] += $NF; if (minProfit == "" || segment[$14] < minProfit) { minProfit = segment[$14]; minSegment = $14 } } END { print minSegment }' Sandbox.csv)` <br />
 	line _if (minProfit == "" || segment[$14] < minProfit)_ akan terus membandingkan total profit dari kolom $NF atau kolom terakhir dengan minProfit hingga didapat profit terkecil. <br /> <br />
c. Tampilkan 3 category yang memiliki total profit paling tinggi <br />
	`awk -F ',' '{sum[$14] += $20} END { for (Category in sum) { print Category } }' Sandbox.csv | sort -nr | head -n 3` <br />
 	line _{sum[$14] += $20}_ akan menjumlahkan nilai di kolom 20 dengan menggunakan kategori di kolom 14 sebagai identifier <br />
  	line _sort -nr | head -n 3_ akan rearrange order dari highest to lowest dan hanya mengoutput 3 teratas. <br /> <br />
d. Cari purchase date dan amount (quantity) dari nama adriaens <br />
	`awk -F ',' 'NR==1 { for (i=1; i<=NF; ++i) headers[i] = $i; next } { if ($6 == "Adriaens Grayland") { print headers[2], $2, headers[18], $18 } }' Sandbox.csv` <br />
 	jika pada kolom 6 ditemukan "Adriaens Grayland" maka kolom 2 dan 18 pada baris yang sama dengan baris ditemukan Adriaens akan di print. <br />
  	Terakhir gabungkan ke dalam 1 script <br />

   	`
    	#!/bin/bash

	# Sales terbanyak
	sales_terbanyak=$(awk -F ',' 'NR == 1 { next } { if ($17 > tertinggi) { tertinggi = $17; cust = $6 } } END { print cust }' Sandbox.csv)
	
	# Segment dengan profit terkecil
	profitMin=$(awk -F ',' 'NR > 1 { segment[$14] += $NF; if (minProfit == "" || segment[$14] < minProfit) { minProfit = segment[$14]; minSegment = $14 } } END { print minSegment }' Sandbox.csv)
	
	# 3 kategori dengan profit terbanyak
	top3cat=$(awk -F ',' '{sum[$14] += $20} END { for (Category in sum) { print Category } }' Sandbox.csv | sort -nr | head -n 3)
	
	# Order date dan quantity dari pemesanan Adriaens
	adriaens=$(awk -F ',' 'NR==1 { for (i=1; i<=NF; ++i) headers[i] = $i; next } { if ($6 == "Adriaens Grayland") { print headers[2], $2, headers[18], $18 } }' Sandbox.csv)
	
	# Print results
	echo "Sales terbanyak: $sales_terbanyak"
	echo "Segment dengan profit terkecil: $profitMin"
	echo "Top 3 Categories: $top3cat"
	echo "Adriaens order date dan quantity:"
	echo "$adriaens"
    	
    	`
### SOAL 2

 #register.sh
a. Buatlah 2 program yaitu login.sh dan register.sh
b. Setiap admin maupun user harus melakukan register terlebih dahulu menggunakan email, username, pertanyaan keamanan dan jawaban, dan password

### SOAL 3
```sh
#!/bin/bash
wget 'https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN' -O genshin.zip
unzip genshin.zip
unzip genshin_character.zip
```
Kita perlu mendownload file zip dari link yang sudah disediakan lalu melakukan unzip terhadap file-file yang telah didownload
```sh
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
```
Nama dari karakter-karakter yang didapat tersebut dalam kondisi ter-enkripsi dengan base64, maka dilakukan dekripsi dengan memasukkan hasil dekripsi ke variabel decrypted kemudian dilakukan rename nama ‘new file’ menjadi isi dari variabel ‘decrypted'
Setelah mendapatkan nama asli dari setiap karakter, cek file 'list_character.csv' lalu masukkan semua item dari karakter tersebut ke variabel 'attributes', 'elements', 'regions'. Pindahkan dalam folder sesuai region dengan format Nama - Region - Elemen - Senjata
```sh
cd ..

echo "JUMLAH SETIAP JENIS SENJATA"

tail -n +2 list_character.csv | awk -F ',' '{print $4}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' |  sort | uniq -c | while read -r count word; do
	echo "$word : $count"
done 

rm genshin_character.zip genshin.zip list_character.csv
```
Lalu, lakukan penghitungan terhadap jumlah berbagai jenis senjata yang terdapat di dalam folder lalu remove file 'list_character.csv', 'genshin_character.zip', 'genshin.zip'
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
Lalu diperlukan script baru yaitu 'search.sh' untuk mencari clue rahasia untuk mendapatkan link gambar. Dilakukan extract dan dekripsi terhadap file-file yang terdapat di dalam 'genshin_character' dan dimasukkan link url tersebut ke dalam 'decrypted_url.txt'
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
