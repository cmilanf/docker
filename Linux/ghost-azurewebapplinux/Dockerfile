# For the time being, source Ghost image is based on Debian 8.9 "Jessie"
# In order to understand this Dockerfile it is mandatory to look also the
# base one at https://github.com/docker-library/ghost/blob/master/1/debian/Dockerfile
FROM ghost:{{TAG}}

LABEL title="Ghost for Microsoft Azure App Service Linux - Let's Encrypt enabled" \
  maintainer="Carlos Milán Figueredo" \
  email="cmilanf@hispamsx.org" \
  version="{{TAG}}" \
  contrib1="https://hub.docker.com/_/ghost/" \
  contrib2="Prashanth Madi <prashanthrmadi@gmail.com> https://github.com/prashanthmadi/azure-ghost/" \
  contrib3="FART - Find and Replace Text command line utility. A grep-like utility for win32. http://fart-it.sourceforge.net/" \
  url1="https://calnus.com" \
  url2="http://www.hispamsx.org" \
  bbs="telnet://bbs.hispamsx.org" \
  twitter="@cmilanf" \
  thanksto="Beatriz Sebastián Peña"

# App Settings and environment variables needed for this container to work.
# Azure WebApp Linux persistent storage is at /home
LABEL WEBAPP_CUSTOM_HOSTNAME="Custom DNS of your webapp. Ex: beta.calnus.com" \
  WEBAPP_NAME="The Azure WebApp name. Ex: calnus-beta" \
  RESOURCE_GROUP="The Azure Resource Group naame where the Azure WebApp is deployed." \
  GHOST_CONTENT="Ghost installation directory, must be in persistent storage. Default: /home/site/wwwroot" \
  GHOST_URL="URL used for accesing the blog. It will be HTTP instead of HTTPS as Azure WebApp takes care of it. Ex: http://beta.calnus.com" \
  DB_TYPE="Database type, that can be 'mysql' or 'sqlite'. For the time being, only 'mysql' is supported in Azure WebApp Linux" \
  DB_HOST="Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com. This should be created by ARM template." \
  DB_NAME="Name of the MySQL database. This should be created by ARM template." \
  DB_USER="Database username for authentication. This should be created by ARM template." \
  DB_PASS="Password for authenticating with database. WARNING: it will be visible from Azure Portal. This should be created by ARM template." \
  SMTP_SERVICE="Service that will be used for sending email. Ex: SendGrid. Full list available at https://github.com/nodemailer/nodemailer/blob/0.7/lib/wellknown.js" \
  SMTP_FROM="Sender email address of the blog. Ex: blog@calnus.com" \
  SMTP_USER="Username used in SMTP authentication." \
  SMTP_PASSWORD="Password used in SMTP authentication. WARNING: It will be clearly visible under Azure portal and stored in plain text in the container." \
  LETSENCRYPT_EMAIL="Email used for TLS certificate generation in Let's Encrypt. Expiration notifications will be recieved in this mailbox." \
  AZUREAD_SP_URL="URL of the Azure AD Service Principal used to upload and bind certificates. This should be created by the Create-AzureADSP script. Ex: http://calnus-beta" \
  AZUREAD_SP_PASSWORD="Password of the Azure AD Service Principal." \
  AZUREAD_SP_TENANTID="Tenant ID of the Azure AD Service Principal" \
  HTTP_CUSTOM_ERRORS="Enable NGINX friendly 404 and 50x errors" 
  
# Do not worry about root password being widely known, there will be no external
# connection to the container. Also, I couldn't help but using linuxlogo, just love it
RUN apt-get -y update \
  && apt-get install -y --no-install-recommends lsof at openssl openssh-server supervisor cron git nano jq less linuxlogo unzip \
  && echo "root:Docker!" | chpasswd \
  && echo "30 * * * * /usr/bin/linuxlogo -L 11 -u > /etc/motd" > /etc/cron.d/linuxlogo \
  && chmod 755 /etc/cron.d/linuxlogo \
  && /usr/bin/linuxlogo -L 11 -u > /etc/motd

# I plan on running Let's Encrypt certbot in the container, so the Azure CLI tool
# will come handy for updating the TLS certificate.
RUN set -ex \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
  tee /etc/apt/sources.list.d/azure-cli.list \
  && echo "deb http://ftp.debian.org/debian jessie-backports main" | \
  tee /etc/apt/sources.list.d/jessie-backports.list \
  && apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 \
  && apt-get -y --no-install-recommends install apt-transport-https net-tools \
  && apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y --no-install-recommends install azure-cli \
  && apt-get -y --no-install-recommends install certbot nginx -t jessie-backports \
  && apt-get -y autoremove \
  && apt-get -y autoclean \
  && set +ex

# Workaround for issue with Azure database for MySQL - will be removed later
# Credit to: Prashanth Madi <prashanthrmadi@gmail.com> https://github.com/prashanthmadi/azure-ghost/
RUN cd current \
  && npm install mysqljs/mysql \
  && cd /var/lib/ghost

COPY sshd_config /etc/ssh/
COPY init-container.bash /usr/local/bin/
COPY migrate-util.bash /usr/local/bin/
COPY supervisord-container.conf /etc/supervisor/conf.d/
COPY convertLetsEncryptToPfx.bash /usr/local/bin/
COPY update-azurewebapp-tls.bash /usr/local/bin/
COPY init-letsencrypt.sh /usr/local/bin/
COPY var-check.bash /usr/local/bin/
COPY nginx-default.conf /etc/nginx/sites-available/default
COPY .bashrc /root/
COPY http_custom_errors.zip /root/

# Ghost blog uses port 2368 and do not require an HTTP server, however, it is useful to have
# nginx in front of it for Let's Encrypt. We will be exposing just the TCP/2222 (SSH) and the
# TCP/80 (HTTP) as Azure WebApp already takes care of the TLS encryption in their front-end
EXPOSE 2222 80

# We will be using the ENTRYPOINT of the base image, just adding our own initialization
CMD ["/usr/local/bin/init-container.bash"]
