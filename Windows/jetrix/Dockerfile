FROM microsoft/nanoserver:latest

LABEL title="Jetrix Tetrinet Server Docker Image" \
    maintainer="Carlos Milán Figueredo" \
    email="cmilanf@hispamsx.org" \
    version="1.0" \
    contrib1="Jetrix - http://jetrix.sourceforge.net/" \
    url="https://calnus.com" \
    twitter="@cmilanf" \
    usage="docker run -d -p 31457:31457 -p 8080:8080 -p 80:80 -h myhostname.domain.com --name jetrix cmilanf/jetrix" \
    thanksto="Beatriz Sebastián Peña"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; $VerbosePreference = 'Continue'; "]

ENV JAVA_VERSION 1.8.0.141-1
ENV JAVA_ZIP_VERSION 1.8.0-openjdk-1.8.0.141-1.b16
ENV JAVA_SHA256 2911ccece06500cc5bd37cb76028d4bd2b6261cb7f77e39404895e18d430d383
ENV JAVA_HOME C:\\java-${JAVA_ZIP_VERSION}.ojdkbuild.windows.x86_64

COPY Packages/Microsoft-NanoServer-IIS-Package.cab C:/Windows/Temp
COPY Packages/Microsoft-NanoServer-IIS-Package_en-US.cab C:/Windows/Temp
COPY unattend.xml C:/Windows/Temp
COPY tetriweb.zip C:/Windows/Temp

WORKDIR C:/Windows/Temp
RUN Invoke-WebRequest $('https://github.com/ojdkbuild/ojdkbuild/releases/download/{0}/java-{1}.ojdkbuild.windows.x86_64.zip' -f $env:JAVA_VERSION, $env:JAVA_ZIP_VERSION) -UserAgent 'NativeHost' -OutFile 'openjdk.zip' -UseBasicParsing ; \
    if ((Get-FileHash openjdk.zip -Algorithm sha256).Hash -ne $env:JAVA_SHA256) {exit 1} ; \
    Expand-Archive openjdk.zip -DestinationPath C:/ ; \
    $env:PATH = '{0}\bin;{1}' -f $env:JAVA_HOME, $env:PATH ; \
    Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\\' -Name Path -Value $env:PATH ; \
    Remove-Item -Path openjdk.zip

RUN cmd.exe /c "dism.exe /online /apply-unattend:.\unattend.xml" ; \
    Start-Service w3svc ; \
    Expand-Archive -Path tetriweb.zip -DestinationPath C:/inetpub/wwwroot -Force
    
RUN Invoke-WebRequest 'https://downloads.sourceforge.net/project/jetrix/Jetrix%20TetriNET%20Server/0.2.3/jetrix-0.2.3.zip' -UserAgent 'NativeHost' -OutFile jetrix-0.2.3.zip ; \
    Expand-Archive -Path jetrix-0.2.3.zip -DestinationPath C:/ -Force

EXPOSE 31457 8080 80

WORKDIR C:/jetrix-0.2.3
ENTRYPOINT [ "c:\\jetrix-0.2.3\\jetrix.bat" ]
