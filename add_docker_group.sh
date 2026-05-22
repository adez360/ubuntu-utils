#!/bin/bash

# Ensure the docker group exists
if ! getent group docker > /dev/null; then
    echo "Creating docker group..."
    groupadd docker
fi

# Iterate through directories in /home
for user_dir in /home/*; do
    if [ -d "$user_dir" ]; then
        username=$(basename "$user_dir")
        
        # Check if the user exists in /etc/passwd
        if id "$username" >/dev/null 2>&1; then
            echo "Adding user '$username' to docker group..."
            usermod -aG docker "$username"
        else
            echo "Directory /home/$username exists but user '$username' not found in system. Skipping."
        fi
    fi
done

echo "Done."
