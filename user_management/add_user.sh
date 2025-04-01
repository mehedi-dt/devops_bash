#!/bin/bash

# Check if the script is run as root (or with sudo)
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Prompt for username
read -p "Enter the username: " username

# Check if the username already exists
if id "$username" &>/dev/null; then
    echo "User '$username' already exists. Please choose a different username."
    exit 1
fi

# Ask whether to disable password authentication
read -p "Do you want to disable password authentication for '$username'? (y/n): " disable_password

if [ "$disable_password" == "y" ]; then
    sudo adduser --disabled-password --gecos "" $username
    sudo passwd -d "$username"
    echo "Password authentication has been disabled for '$username'."
else
    sudo adduser --gecos "" $username
fi

# Prompt for the public SSH key
read -p "Enter the user's public SSH key: " ssh_key

# Create a .ssh directory and authorized_keys file for the user
mkdir -p "/home/$username/.ssh"
echo "$ssh_key" >> "/home/$username/.ssh/authorized_keys"

# Set proper permissions on the .ssh directory and authorized_keys file
chown -R "$username:$username" "/home/$username/.ssh"
chmod 700 "/home/$username/.ssh"
chmod 600 "/home/$username/.ssh/authorized_keys"

# Ask whether to add the user to the sudo group
read -p "Do you want to add '$username' to the sudo group? (y/n): " add_to_sudo

# Check the user's response
if [ "$add_to_sudo" == "y" ]; then
    usermod -aG sudo "$username"
    echo "User '$username' has been added to the sudo group."
else
    echo "User '$username' has not been added to the sudo group."
fi

# Print a message indicating success
echo "User '$username' has been created with SSH key-based authentication."