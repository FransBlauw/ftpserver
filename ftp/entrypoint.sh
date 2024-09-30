#!/bin/bash
# set -e

USER_CSV=${FTP_USER_CSV:-/config/users.csv}

if [ -f "$USER_CSV" ]; then
    echo "Processing users from $USER_CSV"

    # Skip the header and read each line
    tail -n +2 "$USER_CSV" | while IFS=, read -r username password
    do
        pure-pw show "$username" &>/dev/null
        userExists=$?
        if [ $userExists -eq 0 ]; then
            echo "User $username already exists. Skipping."
        else
            echo "Creating FTP user: $username with password $password"
            # Create home directory
            mkdir -p /home/ftpusers/$username
            chown ftpuser:ftpuser /home/ftpusers/$username

            # Create Pure-FTPd user
            echo -e "$password\n$password" | pure-pw useradd $username -u ftpuser -d /home/ftpusers/$username/ -m
            echo "Done."
        fi
    done

    # Rebuild Pure-FTPd database
    pure-pw mkdb
fi

# Start Pure-FTPd in foreground
exec pure-ftpd -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -p 30000:30009
