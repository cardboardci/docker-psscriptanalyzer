FROM mcr.microsoft.com/powershell:6.1.3-alpine-3.8
RUN apk add --no-cache bash==4.4.19-r1
RUN mkdir -p /opt/microsoft/powershell/6/Modules/PowerShellGet/
COPY rootfs/ /
RUN chmod +x /usr/local/bin/psfmt /usr/local/bin/psscriptanalyzer
SHELL ["pwsh", "-Command"]
RUN Set-PSRepository PSGallery -InstallationPolicy Trusted
RUN Install-Module -Name PSScriptAnalyzer -Force