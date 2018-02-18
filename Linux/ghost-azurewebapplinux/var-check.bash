#!/bin/bash

# This is just an script to check that App Settings were transfered
# correctly to Linux environment variables

printf "######### Environment variable check in progress...\n"
echo -e "#!/bin/sh\n" > /home/bin/var-set.sh
printf "GHOST_URL ---> "
if [ -z ${GHOST_URL+x} ]; then
    printf "UNSET\n"
else 
    printf "SET to %s\n" "$GHOST_URL"
    echo -e "export GHOST_URL=$GHOST_URL\n" >> /home/bin/var-set.sh
fi
printf "GHOST_CONTENT ---> "
if [ -z ${GHOST_CONTENT+x} ]; then 
    printf "UNSET\n"
else 
    printf "SET to %s\n" "$GHOST_CONTENT"
    echo -e "export GHOST_CONTENT=$GHOST_CONTENT\n" >> /home/bin/var-set.sh
fi
printf "GHOST_INSTALL ---> "
if [ -z ${GHOST_INSTALL+x} ]; then
    printf "UNSET\n"
else 
    printf "SET to %s\n" "$GHOST_INSTALL"
    echo -e "export GHOST_INSTALL=$GHOST_INSTALL\n" >> /home/bin/var-set.sh
fi
printf "DB_TYPE ---> "
if [ -z ${DB_TYPE+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$DB_TYPE"
    echo -e "export DB_TYPE=$DB_TYPE\n" >> /home/bin/var-set.sh
fi
printf "DB_HOST ---> "
if [ -z ${DB_HOST+x} ]; then
    printf "UNSET\n"
else 
    printf "SET to %s\n" "$DB_HOST"
    echo -e "export DB_HOST=$DB_HOST\n" >> /home/bin/var-set.sh
fi
printf "DB_NAME ---> "
if [ -z ${DB_NAME+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$DB_NAME"
    echo -e "export DB_NAME=$DB_NAME\n" >> /home/bin/var-set.sh
fi
printf "DB_USER ---> "
if [ -z ${DB_USER+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$DB_USER"
    echo -e "export DB_USER=$DB_USER\n" >> /home/bin/var-set.sh
fi
printf "WEBAPP_CUSTOM_HOSTNAME ---> "
if [ -z ${WEBAPP_CUSTOM_HOSTNAME+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$WEBAPP_CUSTOM_HOSTNAME"
    echo -e "export WEBAPP_CUSTOM_HOSTNAME=$WEBAPP_CUSTOM_HOSTNAME\n" >> /home/bin/var-set.sh
fi
printf "WEBAPP_NAME ---> "
if [ -z ${WEBAPP_NAME+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$WEBAPP_NAME"
    echo -e "export WEBAPP_NAME=$WEBAPP_NAME\n" >> /home/bin/var-set.sh
fi
printf "LETSENCRYPT_EMAIL ---> "
if [ -z ${LETSENCRYPT_EMAIL+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$LETSENCRYPT_EMAIL"
    echo -e "export LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL\n" >> /home/bin/var-set.sh
fi
printf "SMTP_FROM ---> "
if [ -z ${SMTP_FROM+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$SMTP_FROM"
    echo -e "export SMTP_FROM=$SMTP_FROM\n" >> /home/bin/var-set.sh
fi
printf "SMTP_SERVICE ---> "
if [ -z ${SMTP_SERVICE+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$SMTP_SERVICE"
    echo -e "export SMTP_SERVICE=$SMTP_SERVICE\n" >> /home/bin/var-set.sh
fi
printf "SMTP_USER ---> "
if [ -z ${SMTP_USER+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$SMTP_USER"
    echo -e "export SMTP_USER=$SMTP_USER\n" >> /home/bin/var-set.sh
fi
printf "SMTP_PASSWORD ---> "
if [ -z ${SMTP_PASSWORD+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$SMTP_PASSWORD"
    echo -e "export SMTP_PASSWORD=$SMTP_PASSWORD\n" >> /home/bin/var-set.sh
fi
printf "AZUREAD_SP_URL ---> "
if [ -z ${AZUREAD_SP_URL+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$AZUREAD_SP_URL"
    echo -e "export AZUREAD_SP_URL=$AZUREAD_SP_URL\n" >> /home/bin/var-set.sh
fi
printf "AZUREAD_SP_TENANTID ---> "
if [ -z ${AZUREAD_SP_TENANTID+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$AZUREAD_SP_TENANTID"
    echo -e "export AZUREAD_SP_TENANTID=$AZUREAD_SP_TENANTID\n" >> /home/bin/var-set.sh
fi
printf "AZUREAD_SP_PASSWORD ---> "
if [ -z ${AZUREAD_SP_PASSWORD+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$AZUREAD_SP_PASSWORD"
    echo -e "export AZUREAD_SP_PASSWORD=$AZUREAD_SP_PASSWORD\n" >> /home/bin/var-set.sh
fi
printf "RESOURCE_GROUP ---> "
if [ -z ${RESOURCE_GROUP+x} ]; then
    printf "UNSET\n"
else
    printf "SET to %s\n" "$RESOURCE_GROUP"
    echo -e "export RESOURCE_GROUP=$RESOURCE_GROUP\n" >> /home/bin/var-set.sh
fi
chmod +x /home/bin/var-set.sh
printf "######### Environment variable check finished\n"
