FROM almalinux:9.7

# Latest version
ARG DSS_VERSION=14.2.2

ENV DSS_PORT=${DSS_PORT:-10000} \
    DSS_DATADIR=${DSS_DATADIR:-/home/dataiku/dss} \
    DSS_INSTALLDIR=/home/dataiku/dataiku-dss-$DSS_VERSION \
    DSSKIT=dataiku-dss-$DSS_VERSION \
    BUILD_DEPS="acl alsa-lib \
                dejavu-sans-fonts \
                google-noto-sans-cjk-ttc-fonts \
                google-noto-serif-cjk-ttc-fonts \
                google-noto-sans-thai-fonts \
                google-noto-serif-thai-fonts \
                diffutils \ 
                expat \
                file fontconfig freetype \
                git glibc-langpack-en gtk3 \
                java-17-openjdk-headless \
                libcurl-devel libgfortran libgomp libicu-devel libX11-xcb libxml2-devel libXScrnSaver \
                libreoffice-writer libreoffice-impress libreoffice-calc \
                mesa-libgbm \
                ncurses-compat-libs nginx npm nss \
                openssl-devel \
                procps-ng \
                python3 python3-devel\
                R-core-devel \
                tini \
                unzip \
                zip" \
    R_DEPS="'base64enc',\
            'curl',\
            'dplyr',\
            'filelock',\
            'ggplot2','gtools',\
            'httr',\
            'IRkernel',\
            'RJSONIO','rmarkdown',\
            'sparklyr',\
            'tidyr'"

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/
WORKDIR /home/dataiku

# Dataiku account and data dir setup
RUN useradd dataiku && \
    mkdir -p $DSS_DATADIR && \
    chown -Rh dataiku:dataiku /home/dataiku $DSS_DATADIR && \
    dnf -y install epel-release && \
    dnf -y update && \
    dnf -y module switch-to nodejs:22 && \
    dnf -y install --enablerepo=crb $BUILD_DEPS && \
# Download and extract DSS kit
    cd /home/dataiku && \
    echo "+ Downloading kit" && \
    curl -OsS https://cdn.downloads.dataiku.com/public/studio/$DSS_VERSION/$DSSKIT.tar.gz && \
    echo "+ Extracting kit" && \
    tar xf $DSSKIT.tar.gz && \
    rm $DSSKIT.tar.gz && \
    $DSSKIT/scripts/install/installdir-postinstall.sh $DSSKIT && \
    (cd $DSS_INSTALLDIR/resources/graphics-export && npm install puppeteer@24.8.2 fs) && \
    chown -Rh dataiku:dataiku $DSS_INSTALLDIR && \
    mkdir -p /usr/local/lib/R/site-library && \
    R --slave --no-restore -e "install.packages(c(${R_DEPS}), \
    '/usr/local/lib/R/site-library', \
    repos='https://cloud.r-project.org')" && \
    dnf clean all

USER dataiku

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["run"]