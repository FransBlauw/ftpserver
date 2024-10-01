#!/bin/bash
# set -e

USER_CSV=${FTP_USER_CSV:-/config/users.csv}

PASSWD_FILE="/etc/pure-ftpd/passwd/pureftpd.passwd"
PURE_DB="/etc/pure-ftpd/passwd/pureftpd.pdb"
PURE_FTPD_FLAGS=""

if [ -e $PASSWD_FILE ]
then
    echo "Password file already exists. Loading users..."
    pure-pw mkdb "$PURE_DB" -f "$PASSWD_FILE"
fi

if [ -e /etc/ssl/private/pure-ftpd.pem ]
then
    echo "Enabling TLS..."
    PURE_FTPD_FLAGS="$PURE_FTPD_FLAGS --tls=1 "
fi

if [ -f "$USER_CSV" ]; then
    echo "Processing users from $USER_CSV"

    # Skip the header and read each line
    tail -n +2 "$USER_CSV" | while IFS=, read -r username password
    do
        pure-pw show "$username" -f "$PASSWD_FILE" -F "$PURE_DB" &>/dev/null
        userExists=$?
        if [ $userExists -eq 0 ]; then
            echo "User $username already exists. Skipping."
        else
            echo "Creating FTP user: $username with password $password"
            # Create home directory
            mkdir -p /home/ftpusers/$username/www

            chown -R ftpuser:ftpgroup /home/ftpusers/$username

            # Create Pure-FTPd user
            echo -e "$password\n$password" | pure-pw useradd $username -u ftpuser -d /home/ftpusers/$username/ -N 50 -m -f "$PASSWD_FILE" -F "$PURE_DB"
            echo "Done."
        fi
    done
fi

# Start Pure-FTPd in foreground
echo "Starting Pure-FTPd..."
exec pure-ftpd -l puredb:$PURE_DB -E -j -R -p 30000:30009 $PURE_FTPD_FLAGS
# ./run.sh -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST

