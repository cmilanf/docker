#!/bin/bash

# Logging explined at: https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time
exec &> >(tee -a /home/LogFiles/init-container.log)
date

# Variable checking, just to test if APPSETTINGS -> ENV was correctly performed
/usr/local/bin/var-check.bash

# Directory creation must be here rather than in the Dockerfile.
# This is due to /home being in a CIFS share pointing to Azure Storage,
# so it only exist AFTER full boot.
mkdir -v -p /var/run/sshd
mkdir -v -p /home/LogFiles/letsencrypt
mkdir -v -p /home/LogFiles/supervisor
mkdir -v -p /home/letsencrypt/workdir
mkdir -v -p "$GHOST_CONTENT"

# Prepare the nginx configuration
sed -i -e "s#{{WEBAPP_CUSTOM_HOSTNAME}}#$WEBAPP_CUSTOM_HOSTNAME#g" /etc/nginx/sites-available/default
if [ $HTTP_CUSTOM_ERRORS == "true" ]; then
    mkdir -v -p /home/site/wwwroot/.error
    unzip -n /root/http_custom_errors.zip -d "$GHOST_CONTENT/.error/"
    sed -i -e "s/#http_custom_errors# //g" /etc/nginx/sites-available/default
fi

# Azure WebApp Linux currently doesn't support SQLite, so MySQL is the only option.
case $DB_TYPE in
    mysql)
        echo "Setting up Ghost for MySQL..."
        gosu node ghost config --no-prompt --db="mysql" --dbhost="$DB_HOST" --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --url="$GHOST_URL"
        gosu node ghost config --no-prompt database.connection.port 3306
        gosu node ghost config --no-prompt database.connection.charset "utf8"
        ;;
    *)
        echo "Setting up Ghost for SQLite..."
        gosu node ghost config --no-prompt --db="sqlite3" --url="$GHOST_URL" --dbpath "$GHOST_CONTENT/data/ghost.db"
        ;;
esac

gosu node ghost config --no-prompt paths.contentPath "$GHOST_CONTENT"
gosu node ghost config --no-prompt server.host 127.0.0.1
gosu node ghost config --no-prompt process local
gosu node ghost config --no-prompt mail.transport "SMTP"
gosu node ghost config --no-prompt mail.options.from "$SMTP_FROM"
gosu node ghost config --no-prompt mail.options.service "$SMTP_SERVICE"
gosu node ghost config --no-prompt mail.options.auth.user "$SMTP_USER"
gosu node ghost config --no-prompt mail.options.auth.pass "$SMTP_PASSWORD"

# Migration of the SQLite database to MySQL
/usr/local/bin/migrate-util.bash

# Let's Encrypt certificate generation. It won't work unless nginx is running
# and listening port 80. That won't happend until supervisord runs. As no further
# commands are allowed to run after supervisor, I'm scheduling it for execution
# after 3 minutes. This should be enough time to start up nginx.
at -f /usr/local/bin/init-letsencrypt.sh now + 3 minutes

# Supervisor is the final container executable. It will launch all the supporting
# servioces the container needs: SSH, GHOST, NGINX and ATD
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
