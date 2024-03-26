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

## register.sh

#!/bin/bash

#Function to check if email is already registered
function check_email() {
  local email="$1"
  if grep -q "^$email:" users.txt; then
    return 0  # Email found
  else
    return 1  # Email not found
  fi
}
Fungsi ini bertujuan untuk memeriksa apakah email yang dimasukkan telah terdaftar, mengecek apakah email tersebut sudah ada dalam file users.txt, serta mengembalikan nilai 0 jika email ditemukan, dan 1 jika tidak ditemukan.

#Function to encrypt password 
function encrypt_password() {
  echo -n "$1" | base64
}
Fungsi ini bertujuan untuk mengenkripsi password menggunakan base64, menerima satu parameter, yaitu password yang ingin dienkripsi, menggunakan perintah base64 untuk melakukan enkripsi.

#Function to register a new user account
function register() {
  local email="$1"
  local username="$2"
  local security_question="$3"
  local security_answer="$4"
  local password="$5"
  local user_type="user"

#Check for "admin" in email and set admin flag
    if [[ "$email" == admin ]]; then
        user_type="admin"
    fi

#Check if email is already registered
  check_email "$email"
  if [ $? -eq 0 ]; then
    echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER FAILED>  Email $email already registered." >&2
    echo "Email $email already registered." >&2
    exit 1
  fi

#Validate password 
  while true; do 
    read -s -p "Enter password: " password
    echo
    if [[ "$password" =~ [[:upper:]] && "$password" =~ [[:lower:]] && "$password" =~ [[:digit:]] && ${#password} -ge 8 ]]; then
      break
    else
      echo "Password must be at least 8 characters long and  contain at least one uppercase letter, one lowercase letter, and one digit."
      echo "Please try again."
    fi
  done

  #Encrypt password
  local encrypted_password=$(encrypt_password "$password")

  #Write user data to users.txt with admin flag
  echo "$email:$username:$security_question:$security_answer:$encrypted_password:$user_type" >> users.txt

  if [[ $user_type == "admin" ]]; then
    echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] Admin $username registered successfully." >> auth.log
    echo "Admin $username registered successfully."
  else
    echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] User $username registered successfully." >> auth.log
    echo "User $username registered successfully."
  fi
}
Fungsi ini bertujuan untuk mendaftarkan akun pengguna baru.
Menerima lima parameter: email, username, pertanyaan keamanan, jawaban keamanan, dan password.
Memeriksa apakah email yang dimasukkan sudah terdaftar menggunakan check_email().
Memvalidasi password sesuai dengan kriteria yang ditentukan (minimal 8 karakter, mengandung setidaknya satu huruf kapital, satu huruf kecil, dan satu angka).
Mengenkripsi password menggunakan encrypt_password().
Menyimpan data pengguna ke dalam file users.txt dengan format: email:username:pertanyaan_keamanan:jawaban_keamanan:password:user_type.
Jika email mengandung kata "admin", maka pengguna akan ditetapkan sebagai admin.
Mencatat keberhasilan registrasi ke dalam file auth.log.
Memberikan pesan keberhasilan registrasi kepada pengguna.

#Main script 
#Create users.txt if it doesnt exist
touch users.txt # add this line to create the file if it doesnt exist
echo "User Registration"
read -p "Enter email: " email
read -p "Enter username: " username
read -p "Enter security question: " security_question
read -p "Enter security answer: " security_answer
read -sp "Password: " password
echo

#Call the register function to complete registration
register "$email" "$username" "$security_question" "$security_answer" "$password"

Membuat file users.txt jika belum ada lalu Meminta pengguna untuk memasukkan data registrasi, termasuk email, username, pertanyaan keamanan, jawaban keamanan, dan password.
dan akhirnya memanggil fungsi register() untuk menyelesaikan proses registrasi.

## login.sh

#!/bin/bash

#Function to display the login  menu
function show_login_menu() {
    echo "Welcome to Login System"
    echo "1. Login"
    echo "2. Forgot Password"
    read -p "Enter your choice: " choice
    case $choice in
        1)
            login
            ;;
        2)
            forgot_password
            ;;
        *)
            echo "Invalid choice. Please select 1 or 2."
            ;;
    esac
}
Fungsi ini bertujuan untuk menampilkan menu login lalu memberikan pilihan untuk login atau lupa password dan akan membaca input dari pengguna untuk memilih opsi. lalu memanggil fungsi login() jika pengguna memilih untuk login, atau forgot_password() jika pengguna memilih lupa password.

#Function to perform the login process
function login() {
    read -p "Enter email: " email
    read -s -p "Enter password: " password
    echo

    # Search for the user in users.txt
    local user_info=$(grep "^$email:" /Users/syahrhm/sisop1/users.txt)

    # If the user is not found
    if [ -z "$user_info" ]; then
        echo "User with email $email not found."
        log_message "LOGIN FAILED" "Failed login attempt on user with email $email"
        show_login_menu
        return
    fi

    # Retrieve the password info from encryption
    local encrypted_password=$(echo "$user_info" | cut -d: -f5)

    # Decrypt the password using base64
    local decrypted_password=$(echo "$encrypted_password" | base64 -d)

    # Check if the entered password matches the stored password
    if [ "$password" != "$decrypted_password" ]; then
        echo "Incorrect password."
        log_message "LOGIN FAILED" "Failed login attempt on user with email $email"
        show_login_menu
        return
    fi

    # Check if the user is an admin
    local user_type=$(echo "$user_info" | cut -d: -f6)
    if [ "$user_type" != "admin" ]; then
        echo "Welcome!"
        log_message "LOGIN SUCCESS" "User $email logged in successfully"
        return
    fi

    echo "Login successful!"
    log_message "LOGIN SUCCESS" "User $email logged in successfully"
    admin_menu "$email"
}
login():

Fungsi ini bertujuan untuk melakukan proses login pengguna, meminta pengguna untuk memasukkan email dan password lalu mencari informasi pengguna berdasarkan email dari file users.txt.
Jika pengguna tidak ditemukan, maka akan ditampilkan pesan kesalahan dan memanggil kembali menu login lalu mengambil password terenkripsi dari data pengguna dan mendekripsi menggunakan base64 dan akan membandingkan password yang dimasukkan oleh pengguna dengan password yang terenkripsi.
Jika password cocok, memeriksa apakah pengguna adalah admin atau bukan. Jika admin, memanggil admin_menu(), jika tidak, menampilkan pesan selamat datang.

#Function to handle forgot password
function forgot_password() {
    read -p "Enter email: " email
    
    # Search for the user in users.txt
    local user_info=$(grep "^$email:" /Users/syahrhm/sisop1/users.txt)
    
    # If the user is not found
    if [ -z "$user_info" ]; then
        echo "User with email $email not found."
        log_message "LOGIN FAILED" "Failed login attempt on user with email $email"
        show_login_menu
        return
    fi
    
    # Retrieve security question info from data
    local security_question=$(echo "$user_info" | cut -d: -f3)
    
    # Prompt the user to answer the security answer
    read -p "Security Question: $security_question " provided_security_answer
    
    # Retrieve the stored security aswer from data
    local stored_security_answer=$(echo "$user_info" | cut -d: -f4)
    
    # Check if teh provided answer matches the stored security answer
    if [ "$provided_security_answer" != "$stored_security_answer" ]; then
        echo "Incorrect answer."
        log_message "LOGIN FAILED" "Failed login attempt on user with email $email"
        show_login_menu
        return
    fi
      
    # Retrieve and display the user's password
    local encrypted_password=$(echo "$user_info" | cut -d: -f5)
    local decrypted_password=$(echo "$encrypted_password" | base64 -d)
    echo "Your password is: $decrypted_password"
    log_message "PASSWORD RECOVERY" "Password recovery for user with email $email"
    show_login_menu
}

Fungsi ini bertujuan untuk menangani lupa password dan akan meminta pengguna untuk memasukkan email lalu mencari informasi pengguna berdasarkan email dari file users.txt.
Jika pengguna tidak ditemukan, menampilkan pesan kesalahan dan memanggil kembali menu login dan mengambil pertanyaan keamanan yang terkait dengan email tersebut setelah itu eminta pengguna untuk menjawab pertanyaan keamanan. Membandingkan jawaban yang diberikan dengan jawaban yang tersimpan.
Jika jawaban benar, akan menampilkan password pengguna.

#Function to display the admin menu
function admin_menu() {
    local email="$1"
    while true; do
        echo "Admin Menu"
        echo "1. Add User"
        echo "2. Edit User"
        echo "3. Remove User"
        echo "4. Logout"
        read -p "Choose an option: " admin_option
    
        case $admin_option in
            1)
                add_user
                ;;
            2)
                read -p "Enter user's email to edit: " edit_email
                edit_user "$edit_email"
                ;;
            3)
                read -p "Enter user's email to remove: " remove_email
                remove_user "$remove_email"
                ;;
            4)
                echo "Logging out..."
                log_message "LOGOUT" "User $email logged out"
                exit 0
                ;;
            *)
                echo "Invalid option. Please choose again."
                ;;
        esac
   done
}

#start the login menu
show_login_menu

Fungsi ini bertujuan untuk menampilkan menu admin setelah login lalu memberikan pilihan untuk menambahkan, mengedit, atau menghapus pengguna, serta logout dan akan membaca input dari pengguna untuk memilih opsi setelah ituemanggil fungsi yang sesuai dengan pilihan yang dibuat.
Memanggil show_login_menu() untuk memulai proses login.

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
```sh
cd ..

echo "JUMLAH JENIS SENJATA"

tail -n +2 list_character.csv | awk -F ',' '{print $4}' | sed 's/^[[:space:]]//;s/[[:space:]]$//' |  sort | uniq -c | while read -r count word; do
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
