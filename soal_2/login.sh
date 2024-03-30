
#!/bin/bash

# Function to display the login  menu
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

# Function to perform the login process
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

# Function to handle forgot password
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

# Function to display the admin menu
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

# start the login menu
show_login_menu
