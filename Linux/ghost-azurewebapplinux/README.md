# Ghost for Microsoft Azure AppService Linux - Let's Encrypt enabled

This folder has all the needed items to perform a successful implementation of [Ghost](https://ghost.org) blog platform in Azure App Service Linux, based on their [official image](https://hub.docker.com/_/ghost/) and inspired by [Prashanth Madi](https://github.com/prashanthmadi/azure-ghost) approach. The main differences from these images are:

  * Uses Azure SQL Database for MySQL (already provided by Prashanth image).
  * Provided fully automated [Let's Encrypt](https://letsencrypt.org/) certificate retrieval, upload and binding to the Azure Web App.

# File description in this repostiory

  * **.bashrc**. Standard bash shell initialization script with colorized ls alias.
  * **Create-AzreADSP.bat**. Azure Service Principal creation script. This is needed to upload and bind automatically the generated Let's Encrypt certificates to the Azure WebApp.
  * **Dockerfile**. The main Dockerfile, documented and explained through metadata tag LABELs.
  * **azuredeploy.json**. The Azure Resource Manager template file. Everthing starts here. This template file expects the following:
    * Custom hostnames are previously created in public DNS provider. Ex: calnus.com and www.calnus.com
    * Azure AD Service Principal is created with permissions in the Azure WebApp.
  * **build.bat**. A simple build script that replaces {{TAG}} in the Dockerfile by the specified version. This way official Ghost image and this one are synced.
  * **convertLetsEncryptToPfx.bash**. Let's Encrypt generates PEM files, but Azure only accepts PFX. This scripts makes this conversion.
  * **fart.exe**. [FART](http://fart-it.sourceforge.net/) is *Find And Replace Text* command line utility; somewhat a *grep*-like utility for win32. It is the key of the *build.bat* file.
  * **http_custom_errors.zip**. Several 404 and 500 custom error pages that are optional to use.
  * **init-container.bash**. This is the script called by base image ENTRYPOINT (*/usr/local/bin/docker-entrypoint.sh*). It performs the following tasks:
    * Creates needed directories in persistent storage.
    * Enables custom errors if user specifies so.
    * Configure the Ghost blog.
    * If not previosly done, migrates the database to MySQL.
    * If not previously done, starts Let's Encrypt certificate request and install.
    * Calls [supervisor](http://supervisord.org), that will take care of all the needed processes in the container.
  * **init-letsencrypt.sh**. If not previously done, calls Let's Encrypt through certbot in order to retrieve certificates.
  * **migrate-util.bash**. Migrates the database to MySQL and the content to the Azure presistent storage mounted at /home. As it is a CIFS share, tar archiving must follow symlinks.
  * **nginx-default**. nginx default configuration for ARR SSL, Let's Encrypt and reverse proxy to Ghost.
  * **sshd_config**. Azure AppService Linux SSH mandatory configuration.
  * **supervisor-container.conf**. [supervisord](http://supervisord.org) configuration. It takes cares the process needed for the container are healthy and running:
    * *atd*. A scheduling daemon, used to launch *init-letsencrypt.sh* 3 minutes later.
    * *sshd*. The openssh-server.
    * *cron*. Needed for renewing Let's Encrypt certificates automatically.
    * *nginx*. Reverse proxy for Ghost and Let's Encrypt webroot module server. TLS is managed by front-end servers, so nginx is just listening plain HTTP at port 80.
    * *ghostapp*. The Ghost app server at port TCP/2368.
  * **update-azurewebapss-tls.bash**. Once certbot has generated the TLS certificates, this scripts upload and bind them to the Azure WebApp through the Azure AD Service Principal credentials.
  * **var-check.bash**. A simple script that prints used environments variables. Useful just for logging purposes.

# Requeriments

  * Microsoft Azure subscription. Estimated monthly credit needed is about 80 EUR/month
  * Azure WebApp for Linux. Plan S1 or superior. (~62 EUR/month)
  * SQL Database for MySQL. Plan Basic 50 DTU or superior. (~15 EUR/month)
  * A custom domain name for your blog with www. subdomain.
  * An email address.
  * Optionally, a SendGrid (or other SMTP provider) account.

**It is NOT supported to use SQLite in Azure WebApp Linux** as the persitent storage area at */home* is a CIFS share that doesn't support the file locking features demanded by SQLite. MySQL is the only option.

# How to deploy
Follow the next steps:

  1. Choose a non used Azure WebApp name (ex: calnus), and a custom DNS name you own (ex: calnus.com).
  2. Create the *awverify* entries in your public DNS provider you would use to [map a custom hostname](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain) to an Azure WebApp. Map your custom domain (ex: calnus.com) AND www. subdomain (ex: www.calnus.com).
  3. Create an empty Azure Resource Group, create and Azure AD Service Principal with Contributor permissions in that resource group (sample script [here](https://github.com/cmilanf/docker/blob/master/Linux/ghost-azurewebapplinux/Create-AzureADSP.bat), easily adaptable to bash).
  4. Grab [this Azure Resource Manager template](https://github.com/cmilanf/docker/blob/master/Linux/ghost-azurewebapplinux/azuredeploy.json) and deploy it in your subscription.
  5. After successfull implementation, allow Docker image to be downloaded and executed. You can follow the progress through Kudu.
  6. If needed, adjust your DNS again so Let's Encrypt can sucessfully verify your site.
  7. Restart the webapp or enter in the SSH console and run */usr/local/bin/init-letsencrypt.sh*
  8. Very recommended but not required: **by default the SQL Database for MySQL has his firewall wide open**. It would be a good practice to check the Outbound IP Addresses of the webapp and allow only these IPs in the database firewall.

  [![Azure Deploy](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcmilanf%2Fdocker%2Fmaster%2FLinux%2Fghost-azurewebapplinux%2Fazuredeploy.json)

# Environment variables and ARM template parameters description

  * WEBAPP_CUSTOM_HOSTNAME. Custom DNS of your webapp. Ex: beta.calnus.com
  * WEBAPP_NAME. The Azure WebApp name. Ex: calnus-beta
  * RESOURCE_GROUP. The Azure Resource Group naame where the Azure WebApp is deployed.
  * GHOST_CONTENT. Ghost installation directory, must be in persistent storage. Default: /home/site/wwwroot.
  * GHOST_URL. URL used for accesing the blog. It will be HTTP instead of HTTPS as Azure WebApp takes care of it. Ex: http://beta.calnus.com
  * DB_TYPE. Database type, that can be 'mysql' or 'sqlite'. For the time being, only 'mysql' is supported in Azure WebApp Linux"
  * DB_HOST. Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com. This should be created by ARM template.
  * DB_NAME. Name of the MySQL database. This should be created by ARM template.
  * DB_USER. Database username for authentication. This should be created by ARM template.
  * DB_PASS. Password for authenticating with database. WARNING: it will be visible from Azure Portal. This should be created by ARM template.
  * SMTP_SERVICE. Service that will be used for sending email. Ex: SendGrid. Full list available at https://github.com/nodemailer/nodemailer/blob/0.7/lib/wellknown.js
  * SMTP_FROM. Sender email address of the blog. Ex: blog@calnus.com
  * SMTP_USER. Username used in SMTP authentication.
  * SMTP_PASSWORD. Password used in SMTP authentication. WARNING: It will be clearly visible under Azure portal and stored in plain text in the container.
  * LETSENCRYPT_EMAIL. Email used for TLS certificate generation in Let's Encrypt. Expiration notifications will be recieved in this mailbox.
  * AZUREAD_SP_URL. URL of the Azure AD Service Principal used to upload and bind certificates. This should be created by the Create-AzureADSP script. Ex: http://calnus-beta
  * AZUREAD_SP_PASSWORD. Password of the Azure AD Service Principal.
  * AZUREAD_SP_TENANTID. Tenant ID of the Azure AD Service Principal
  * HTTP_CUSTOM_ERRORS. Enable NGINX friendly 404 and 50x errors
