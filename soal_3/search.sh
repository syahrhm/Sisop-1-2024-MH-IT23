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
