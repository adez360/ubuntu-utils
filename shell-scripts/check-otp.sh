#!/bin/bash

# This script checks all users under /home to see if their .google_authenticator file exists.
# It prints each user and their OTP status.

# Print header
printf "%-20s %-10s\n" "USER" "STATUS"
printf "%-20s %-10s\n" "--------------------" "----------"

# Iterate through each directory in /home
for user_dir in /home/*; do
    # Ensure it's a directory and not the literal string if /home is empty
    [[ -d "$user_dir" ]] || continue

    username=$(basename "$user_dir")
    # The standard file name is .google_authenticator
    otp_file="$user_dir/.google_authenticator"

    if [[ -f "$otp_file" ]]; then
        status="ENABLED"
    else
        status="DISABLED"
    fi

    printf "%-20s %-10s\n" "$username" "$status"
done
