HOST=csb.fransblauw.rocks
mkdir -p ./private/letsencrypt
certbot certonly --standalone --register-unsafely-without-email --agree-tos --non-interactive --config-dir ./private/letencrypt/ --work-dir ./private/letencrypt/ -d $HOST
cp ./private/letsencrypt/live/$HOST/fullchain.pem ./private/fullchain.pem
cp ./private/letsencrypt/live/$HOST/privkey.pem ./private/privkey.pem
cat ./private/fullchain.pem ./private/privkey.pem > ./private/pure-ftpd.pem
