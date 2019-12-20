FROM cardboardci/ci-core:0.0.1-20191220
USER root

ARG VERSION=6.2.3

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates=20190110 \
    && curl -sSL http://mirrors.edge.kernel.org/ubuntu/pool/main/i/icu/libicu60_60.2-3ubuntu3_amd64.deb -o libicu60_60.2-3ubuntu3_amd64.deb \
    && curl -sSL http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb -o libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb \
    && dpkg -i libicu60_60.2-3ubuntu3_amd64.deb libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb \
    && curl -sSL https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" > /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y powershell \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/microsoft/powershell/6/Modules/PowerShellGet/

COPY rootfs/ /
RUN pwsh -Command 'Set-PSRepository PSGallery -InstallationPolicy Trusted' \
    && pwsh -Command 'Install-Module -Name PSScriptAnalyzer -RequiredVersion 1.18.3 -Force' \
    && chmod +x /usr/local/bin/PSFormatter /usr/local/bin/PSScriptAnalyzer

USER cardboardci

##
## Image Metadata
##
ARG build_date
ARG version
ARG vcs_ref
LABEL maintainer = "CardboardCI" \
    \
    org.label-schema.schema-version = "1.0" \
    \
    org.label-schema.name = "psscriptanalyzer" \
    org.label-schema.version = "${version}" \
    org.label-schema.build-date = "${build_date}" \
    org.label-schema.release= = "CardboardCI version:${version} build-date:${build_date}" \
    org.label-schema.vendor = "cardboardci" \
    org.label-schema.architecture = "amd64" \
    \
    org.label-schema.summary = "Powershell linter" \
    org.label-schema.description = "PSScriptAnalyzer is a static code checker for Windows PowerShell modules and scripts" \
    \
    org.label-schema.url = "https://gitlab.com/cardboardci/images/psscriptanalyzer" \
    org.label-schema.changelog-url = "https://gitlab.com/cardboardci/images/psscriptanalyzer/releases" \
    org.label-schema.authoritative-source-url = "https://cloud.docker.com/u/cardboardci/repository/docker/cardboardci/psscriptanalyzer" \
    org.label-schema.distribution-scope = "public" \
    org.label-schema.vcs-type = "git" \
    org.label-schema.vcs-url = "https://gitlab.com/cardboardci/images/psscriptanalyzer" \
    org.label-schema.vcs-ref = "${vcs_ref}" \