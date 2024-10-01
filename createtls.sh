HOST=csb.fransblauw.rocks
mkdir -p ./private/letsencrypt
certbot certonly --standalone --register-unsafely-without-email --agree-tos --non-interactive --config-dir ./private/letsencrypt/ --work-dir ./private/letsencrypt/ -d $HOST
cp ./private/letsencrypt/live/$HOST/fullchain.pem ./private/certificates/fullchain.pem
cp ./private/letsencrypt/live/$HOST/privkey.pem ./private/certificates/privkey.pem
cat ./private/certificates/fullchain.pem ./private/certificates/privkey.pem > ./private/pure-ftpd.pem
