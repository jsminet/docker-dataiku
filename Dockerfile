FROM almalinux:8.9

ARG DSS_VERSION=12.5.2

ENV DSS_PORT=${DSS_PORT:-10000} \
    DSS_DATADIR=/home/dataiku/dss \
    DSS_INSTALLDIR=/home/dataiku/dataiku-dss-$DSS_VERSION \
    DSSKIT=dataiku-dss-$DSS_VERSION \
    BUILD_DEPS="acl alsa-lib \
                expat \
                file freetype \
                git glibc-langpack-en gtk3 \
                java-1.8.0-openjdk \
                libcurl-devel libgfortran libgomp libicu-devel libX11-xcb libxml2-devel libXScrnSaver \
                mesa-libgbm \
                ncurses-compat-libs nginx npm nss \
                openssl-devel \
                python2 python2-devel python36 python36-devel \
                R-core-devel \
                tini \
                unzip \
                zip"

COPY docker-entrypoint.sh /usr/local/bin/
WORKDIR /home/dataiku

# Dataiku account and data dir setup
RUN useradd dataiku && \
    mkdir -p $DSS_DATADIR && \
    chown -Rh dataiku:dataiku /home/dataiku $DSS_DATADIR && \
    yum install -y epel-release && \
    yum install -y --enablerepo=powertools $BUILD_DEPS && \
# Download and extract DSS kit
    cd /home/dataiku && \
    echo "+ Downloading kit" && \
    curl -OsS https://cdn.downloads.dataiku.com/public/studio/$DSS_VERSION/$DSSKIT.tar.gz && \
    echo "+ Extracting kit" && \
    tar xf $DSSKIT.tar.gz && \
    rm /home/dataiku/$DSSKIT.tar.gz && \
# rm -rf $DSS_INSTALLDIR/scripts/install/installdir-postinstall.sh
# rm -rf /home/dataiku/${DSSKIT}
    cd $DSS_INSTALLDIR/resources/graphics-export && \
    npm install puppeteer@13.7.0 fs && \
    chown -Rh dataiku:dataiku $DSS_INSTALLDIR && \
    mkdir -p /usr/local/lib/R/site-library && \
    R --slave --no-restore -e "install.packages( \
    c('httr', 'RJSONIO', 'dplyr', 'curl', 'IRkernel', 'sparklyr', 'ggplot2', 'gtools', 'tidyr', 'rmarkdown', 'base64enc', 'filelock'), \
    '/usr/local/lib/R/site-library', \
    repos='https://cloud.r-project.org')" && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    yum clean all

USER dataiku

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["run"]