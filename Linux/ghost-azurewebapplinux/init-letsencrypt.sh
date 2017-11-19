#!/bin/sh

# We do not need just to renew the Let's Encrypt certificate,
# but also to upload to Azure WebApp and bind it. That's why we
# add a renew hook that calls update-azurewebapp-tls.bash
if ! grep -m 1 -q -- "--renew-hook" /etc/cron.d/certbot; then
    echo "init-letsencrypt.sh: Modifying certbot cron job for Azure WebApps persistent storage..."
    sed -i -e 's#certbot -q renew#certbot --config-dir /home/letsencrypt --work-dir /home/letsencrypt/workdir --logs-dir /home/LogFiles/letsencrypt --renew-hook /usr/local/bin/update-azurewebapp-tls.bash -q renew#g' /etc/cron.d/certbot
fi

# If the certificate doesn't exists let's generate a new one
# We will set Let's Encrypt config dir to persistent storage.
if [ ! -f /home/letsencrypt/live/$WEBAPP_CUSTOM_HOSTNAME/fullchain.pem ]; then
    certbot certonly --config-dir /home/letsencrypt --work-dir /home/letsencrypt/workdir \
        --logs-dir /home/LogFiles/letsencrypt --webroot --email $LETSENCRYPT_EMAIL --agree-tos \
        -w /home/site/wwwroot -d $WEBAPP_CUSTOM_HOSTNAME -d www.$WEBAPP_CUSTOM_HOSTNAME

    if [ $? -eq 0 ]; then
        echo "init-letsencrypt.sh: Uploading TLS certificate to Azure WebApp..."
        /usr/local/bin/update-azurewebapp-tls.bash
    else
        echo "init-letsencrypt.sh: There was a problem with TLS certificate generation"
    fi
fi
