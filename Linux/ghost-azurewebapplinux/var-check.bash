#!/bin/bash

# This is just an script to check that App Settings were transfered
# correctly to Linux environment variables

printf "######### Environment variable check in progress...\n"
printf "GHOST_URL ---> "
if [ -z ${GHOST_URL+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$GHOST_URL"; fi
printf "GHOST_CONTENT ---> "
if [ -z ${GHOST_CONTENT+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$GHOST_CONTENT"; fi
printf "GHOST_INSTALL ---> "
if [ -z ${GHOST_INSTALL+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$GHOST_INSTALL"; fi
printf "DB_TYPE ---> "
if [ -z ${DB_TYPE+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$DB_TYPE"; fi
printf "DB_HOST ---> "
if [ -z ${DB_HOST+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$DB_HOST"; fi
printf "DB_NAME ---> "
if [ -z ${DB_NAME+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$DB_NAME"; fi
printf "DB_USER ---> "
if [ -z ${DB_USER+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$DB_USER"; fi
printf "WEBAPP_CUSTOM_HOSTNAME ---> "
if [ -z ${WEBAPP_CUSTOM_HOSTNAME+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$WEBAPP_CUSTOM_HOSTNAME"; fi
printf "WEBAPP_NAME ---> "
if [ -z ${WEBAPP_NAME+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$WEBAPP_NAME"; fi
printf "LETSENCRYPT_EMAIL ---> "
if [ -z ${LETSENCRYPT_EMAIL+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$LETSENCRYPT_EMAIL"; fi
printf "SMTP_FROM ---> "
if [ -z ${SMTP_FROM+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$SMTP_FROM"; fi
printf "SMTP_SERVICE ---> "
if [ -z ${SMTP_SERVICE+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$SMTP_SERVICE"; fi
printf "SMTP_USER ---> "
if [ -z ${SMTP_USER+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$SMTP_USER"; fi
printf "SMTP_PASSWORD ---> "
if [ -z ${SMTP_PASSWORD+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$SMTP_PASSWORD"; fi
printf "AZUREAD_SP_URL ---> "
if [ -z ${AZUREAD_SP_URL+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$AZUREAD_SP_URL"; fi
printf "AZUREAD_SP_TENANTID ---> "
if [ -z ${AZUREAD_SP_TENANTID+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$AZUREAD_SP_TENANTID"; fi
printf "RESOURCE_GROUP ---> "
if [ -z ${RESOURCE_GROUP+x} ]; then printf "UNSET\n"; else printf "SET to %s\n" "$RESOURCE_GROUP"; fi
printf "######### Environment variable check finished\n"
