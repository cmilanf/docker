@ECHO OFF
REM Docker build for syncing version with official Ghost image
REM %1 - Official Ghost Docker image tag
REM %2 - (Optional) Additional build options (ex. --no-cache)
MD %TEMP%\docker-build
COPY /Y *.* %TEMP%\docker-build
docker build %2 --build-arg VERSION=%1 -t cmilanf/ghost-azurewebapplinux:%1 %TEMP%\docker-build
RD /S /Q %TEMP%\docker-build
