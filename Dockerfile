FROM mcr.microsoft.com/powershell:6.1.3-alpine-3.8
RUN apk add --no-cache bash==4.4.19-r1
RUN mkdir -p /opt/microsoft/powershell/6/Modules/PowerShellGet/
COPY rootfs/ /
RUN chmod +x /usr/local/bin/PSFormatter /usr/local/bin/PSScriptAnalyzer
SHELL ["pwsh", "-Command"]
RUN Set-PSRepository PSGallery -InstallationPolicy Trusted
RUN Install-Module -Name PSScriptAnalyzer -Force

##
## Image Metadata
##
ARG build_date
ARG version
ARG vcs_ref
LABEL maintainer="CardboardCI" \
    \
    org.label-schema.schema-version="1.0" \
    \
    org.label-schema.name="psscriptanalyzer" \
    org.label-schema.version="${version}" \
    org.label-schema.build-date="${build_date}" \
    org.label-schema.release=="CardboardCI version:${version} build-date:${build_date}" \
    org.label-schema.vendor="cardboardci" \
    org.label-schema.architecture="amd64" \
    \
    org.label-schema.summary="Powershell linter" \
    org.label-schema.description="PSScriptAnalyzer is a static code checker for Windows PowerShell modules and scripts" \
    \
    org.label-schema.url="https://gitlab.com/cardboardci/images/psscriptanalyzer" \
    org.label-schema.changelog-url="https://gitlab.com/cardboardci/images/psscriptanalyzer/releases" \
    org.label-schema.authoritative-source-url="https://cloud.docker.com/u/cardboardci/repository/docker/cardboardci/psscriptanalyzer" \
    org.label-schema.distribution-scope="public" \
    org.label-schema.vcs-type="git" \
    org.label-schema.vcs-url="https://gitlab.com/cardboardci/images/psscriptanalyzer" \
    org.label-schema.vcs-ref="${vcs_ref}" \