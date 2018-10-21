#!/bin/bash

# Logging explined at: https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time
exec &> >(tee -a /home/LogFiles/update-azurewebapp-tls.log)
date
source /home/bin/var-set.sh
echo "update-azurewebapp-tls.bash: Preparing certificate for Azure Webapp import..."
if [ -f /home/letsencrypt/live/$WEBAPP_CUSTOM_HOSTNAME/fullchain.pem ]; then
    # If the certifcate exists, then let's get his thumbprint
    echo "update-azurewebapp-tls.bash: Certificate file found"
    X509_THUMBPRINT=$(openssl x509 -in /home/letsencrypt/live/$WEBAPP_CUSTOM_HOSTNAME/fullchain.pem -noout -fingerprint | sed -e 's/://g' | sed -e 's/SHA1 Fingerprint=//')
    echo "Thumbprint: $X509_THUMBPRINT"

    # PFX conversion, the supported format in Azure
    /usr/local/bin/convertLetsEncryptToPfx.bash

    # Azure Webapp certificate upload and binding through Azure AD Service Principal
    if [ -f /home/letsencrypt/live/$WEBAPP_CUSTOM_HOSTNAME/fullchain.pfx ] && [ -f /home/letsencrypt/live/passfile.txt ]; then
        echo "Azure SP LOGIN..."
        az login --service-principal -u $AZUREAD_SP_URL -p $AZUREAD_SP_PASSWORD --tenant $AZUREAD_SP_TENANTID
        echo "Azure certificate UPLOAD..."
        az webapp config ssl upload \
            --certificate-file /home/letsencrypt/live/$WEBAPP_CUSTOM_HOSTNAME/fullchain.pfx \
            --certificate-password $(cat /home/letsencrypt/live/passfile.txt) \
            --name $WEBAPP_NAME \
            --resource-group $RESOURCE_GROUP
        echo "Azure certificate BINDING..."
        az webapp config ssl bind \
            --certificate-thumbprint $X509_THUMBPRINT \
            --name $WEBAPP_NAME \
            --resource-group $RESOURCE_GROUP \
            --ssl-type SNI
    else
        echo "update-azurewebapp-tls.bash: Required file is missing, passfile.txt or fullchain.pfx"
    fi
else
    echo "update-azurewebapp-tls.bash: Certificate file not found, skipping..."
fi