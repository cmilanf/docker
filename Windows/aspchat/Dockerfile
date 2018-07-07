# escape=`
FROM microsoft/iis:windowsservercore-1803

LABEL title="Classic ASP Chat Docker" `
    maintainer="Carlos Milán Figueredo" `
    version="latest" `
    contrib1="https://stackoverflow.com/questions/40099339/dockerize-asp-classic-on-iis" `
    contrib2="https://github.com/jeremehancock/aspinfo" `
    contrib3="http://planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=8048&lngWId=4" `
    contrib4="https://github.com/stephenmcd/aspchat" `
    url="https://calnus.com" `
    twitter="@cmilanf" `
    usage="docker run -it --rm -p 80:80 -p 443:443 cmilanf/aspchat"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; $VerbosePreference = 'Continue'; "]

RUN Install-WindowsFeature Web-ASP; `
    Install-WindowsFeature Web-CGI; `
    Install-WindowsFeature Web-ISAPI-Ext; `
    Install-WindowsFeature Web-ISAPI-Filter; `
    Install-WindowsFeature Web-Includes; `
    Install-WindowsFeature Web-HTTP-Errors; `
    Install-WindowsFeature Web-Common-HTTP; `
    Install-WindowsFeature Web-Performance; `
    Install-WindowsFeature WAS; `
    Import-module IISAdministration;

RUN New-Item -Path c:\msi -ItemType Directory; `
    Invoke-WebRequest 'https://download.microsoft.com/download/C/9/E/C9E8180D-4E51-40A6-A9BF-776990D8BCA9/rewrite_amd64.msi' -UseBasicParsing -OutFile c:\msi\urlrewrite2.msi; `
    Start-Process -FilePath 'C:\\Windows\\System32\\msiexec.exe'  -ArgumentList '/i', 'c:\\msi\\urlrewrite2.msi', '/qn', '/norestart', '/L c:\\msi\urlrewrite2.log' -NoNewWindow -Wait; `
    Invoke-WebRequest 'https://download.microsoft.com/download/1/E/7/1E7B1181-3974-4B29-9A47-CC857B271AA2/English/X64/msodbcsql.msi' -UseBasicParsing -OutFile c:\msi\msodbcsql.msi; `
    Start-Process -FilePath 'C:\\Windows\\System32\\msiexec.exe' -ArgumentList '/i', 'c:\\msi\\msodbcsql.msi', 'IACCEPTMSODBCSQLLICENSETERMS=YES', 'ADDLOCAL=ALL', '/qn', '/norestart', '/L c:\\msi\\msodbcsql.log' -NoNewWindow -Wait

RUN Invoke-WebRequest 'https://raw.githubusercontent.com/jeremehancock/aspinfo/master/aspinfo.asp' -OutFile "C:\\inetpub\\wwwroot\\aspinfo.asp" ; `
    $aspchat = @('default.asp', 'functions_js.asp', 'functions_vbs.asp', 'constants_vbs.asp'); `
    foreach($file in $aspchat) { Invoke-WebRequest "https://raw.githubusercontent.com/stephenmcd/aspchat/master/$file" -OutFile "C:\\inetpub\\wwwroot\\$file" }

RUN & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/asp; `
    & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/handlers; `
    & c:\windows\system32\inetsrv\appcmd.exe unlock config /section:system.webServer/modules; `
    & c:\windows\system32\inetsrv\appcmd.exe set config -section:system.webServer/httpErrors -errorMode:Detailed; `
    & c:\windows\system32\inetsrv\appcmd.exe set config -section:asp -scriptErrorSentToBrowser:true

COPY aspinfolite.asp C:\inetpub\wwwroot\

EXPOSE 80