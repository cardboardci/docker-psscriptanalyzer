FROM cardboardci/ci-core:focal
USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apk add --no-cache bash
RUN mkdir -p /opt/microsoft/powershell/6/Modules/PowerShellGet/
COPY rootfs/ /
RUN chmod +x /usr/local/bin/PSFormatter /usr/local/bin/PSScriptAnalyzer
SHELL ["pwsh", "-Command"]
RUN Set-PSRepository PSGallery -InstallationPolicy Trusted
RUN Install-Module -Name PSScriptAnalyzer -RequiredVersion 1.18.3 -Force

##
## Image Metadata
##
ARG build_date
ARG version
ARG vcs_ref
LABEL maintainer="CardboardCI"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="psscriptanalyzer"
LABEL org.label-schema.version="${version}"
LABEL org.label-schema.build-date="${build_date}"
LABEL org.label-schema.release="CardboardCI version:${version} build-date:${build_date}"
LABEL org.label-schema.vendor="cardboardci"
LABEL org.label-schema.architecture="amd64"
LABEL org.label-schema.summary="Powershell linter"
LABEL org.label-schema.description="PSScriptAnalyzer is a static code checker for Windows PowerShell modules and scripts"
LABEL org.label-schema.url="https://gitlab.com/cardboardci/images/psscriptanalyzer"
LABEL org.label-schema.changelog-url="https://gitlab.com/cardboardci/images/psscriptanalyzer/releases"
LABEL org.label-schema.authoritative-source-url="https://cloud.docker.com/u/cardboardci/repository/docker/cardboardci/psscriptanalyzer"
LABEL org.label-schema.distribution-scope="public"
LABEL org.label-schema.vcs-type="git"
LABEL org.label-schema.vcs-url="https://gitlab.com/cardboardci/images/psscriptanalyzer"
LABEL org.label-schema.vcs-ref="${vcs_ref}"