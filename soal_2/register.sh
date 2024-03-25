#!/bin/bash

# Function to check if email is already registered
function check_email() {
  local email="$1"
  if grep -q "^$email:" users.txt; then
    return 0  # Email found
  else
    return 1  # Email not found
  fi
}

# Function to encrypt password 
function encrypt_password() {
  echo -n "$1" | base64
}

# Function to register a new user account
function register() {
  local email="$1"
  local username="$2"
  local security_question="$3"
  local security_answer="$4"
  local password="$5"
  local user_type="user"

# Check for "admin" in email and set admin flag
    if [[ "$email" == admin ]]; then
        user_type="admin"
    fi

# Check if email is already registered
  check_email "$email"
  if [ $? -eq 0 ]; then
    echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER FAILED>  Email $email already registered." >&2
    echo "Email $email already registered." >&2
    exit 1
  fi

# Validate password 
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

  # Encrypt password
  local encrypted_password=$(encrypt_password "$password")

  # Write user data to users.txt with admin flag
  echo "$email:$username:$security_question:$security_answer:$encrypted_password:$user_type" >> users.txt

  if [[ $user_type == "admin" ]]; then
    echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] Admin $username registered successfully." >> auth.log
    echo "Admin $username registered successfully."
  else
    echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] User $username registered successfully." >> auth.log
    echo "User $username registered successfully."
  fi
}

# Main script 
# Create users.txt if it doesnt exist
touch users.txt # add this line to create the file if it doesnt exist
echo "User Registration"
read -p "Enter email: " email
read -p "Enter username: " username
read -p "Enter security question: " security_question
read -p "Enter security answer: " security_answer
read -sp "Password: " password
echo

# Call the register function to complete registration
register "$email" "$username" "$security_question" "$security_answer" "$password"
