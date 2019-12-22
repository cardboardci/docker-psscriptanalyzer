FROM cardboardci/ci-core@sha256:5b93f4c8cc1ddaa809f9c27d0a865a974ccb43e5e3d38334df1b0d77ea1843fb
USER root

ARG VERSION=6.2.3

ARG DEBIAN_FRONTEND=noninteractive

COPY provision/pkglist /cardboardci/pkglist
RUN apt-get update \
    && xargs -a /cardboardci/pkglist apt-get install --no-install-recommends -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates=20190110 \
    && curl -sSL http://mirrors.edge.kernel.org/ubuntu/pool/main/i/icu/libicu60_60.2-3ubuntu3_amd64.deb -o libicu60_60.2-3ubuntu3_amd64.deb \
    && curl -sSL http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb -o libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb \
    && dpkg -i libicu60_60.2-3ubuntu3_amd64.deb libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb \
    && curl -sSL https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" > /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y powershell=${VERSION}-1.ubuntu.18.04 \
    && apt-get clean \
    && rm -rf ./*.deb /var/lib/apt/lists/* \
    && mkdir -p /opt/microsoft/powershell/6/Modules/PowerShellGet/

COPY rootfs/ /
RUN chmod +x /usr/local/bin/PSFormatter /usr/local/bin/PSScriptAnalyzer

USER cardboardci
RUN pwsh -Command 'Set-PSRepository PSGallery -InstallationPolicy Trusted' \
    && pwsh -Command 'Install-Module -Name PSScriptAnalyzer -RequiredVersion 1.18.3 -Force'

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