#!/bin/bash

# Check if the script is run as root (or with sudo)
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Prompt for the username to delete
read -p "Enter the username to delete: " username

# Check if the user exists
if ! id "$username" &>/dev/null; then
    echo "User '$username' does not exist."
    exit 1
fi

# Prompt for confirmation before deleting the user
read -p "Are you sure you want to delete user '$username'? (y/n): " confirmation

if [ "$confirmation" == "y" ]; then
    # Prompt for confirmation to delete the user's home directory
    read -p "Do you want to delete the user's home directory as well? (y/n): " delete_home

    if [ "$delete_home" == "y" ]; then
        # Delete the user and their home directory
        userdel -r "$username"
        if [ $? -eq 0 ]; then
            echo "User '$username' and their home directory have been deleted successfully."
        else
            echo "Failed to delete user '$username' and their home directory."
        fi
    else
        # Delete the user without deleting the home directory
        userdel "$username"
        if [ $? -eq 0 ]; then
            echo "User '$username' has been deleted, but their home directory remains."
        else
            echo "Failed to delete user '$username', but their home directory remains."
        fi
    fi
else
    echo "User '$username' has not been deleted."
fi