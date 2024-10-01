DEFAULT_HOST="fransblauw.rocks"

if [ -z "$1" ]; then
    echo "Using default host: $DEFAULT_HOST"
    HOST=$DEFAULT_HOST
else
    echo "Using host: $1"
    HOST=$1
fi

mkdir -p ./private/letsencrypt
mkdir -p ./private/certificates
certbot certonly --preferred-challenges dns --manual --register-unsafely-without-email --agree-tos --config-dir ./private/letsencrypt/ --work-dir ./private/letsencrypt/ -d *.$HOST
cp ./private/letsencrypt/live/$HOST/fullchain.pem ./private/certificates/fullchain.pem
cp ./private/letsencrypt/live/$HOST/privkey.pem ./private/certificates/privkey.pem
cat ./private/certificates/fullchain.pem ./private/certificates/privkey.pem > ./private/certificates/pure-ftpd.pem
