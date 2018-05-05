@ECHO OFF
REM This simple script will build and upload to Docker Hub all versions
FOR %%I IN (1.17.3,1.18.0,1.18.2,1.18.4,1.21.2,1.21.7,1.22.4) DO (
    ECHO =================== Building version %%I
    CALL build.bat %%I
    IF %ERRORLEVEL% EQU 0 ( docker push cmilanf/ghost-azurewebapplinux:%%I )
)