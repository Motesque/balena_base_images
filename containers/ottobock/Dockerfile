ARG ARCH
FROM balenalib/$ARCH-debian:buster-build-20221215 as build

RUN install_packages \
    wget \
    gcc \
    make \
    libc-dev \
    pkg-config \
    libestr-dev \
    libfastjson-dev \
    zlib1g-dev \
    uuid-dev \
    libgcrypt20-dev \
    libcurl4-gnutls-dev \
    wget

RUN set -e && \
    mkdir /rsyslog && \
    cd /rsyslog && \
    wget https://nyc3-download-01.motesque.com/packages/rsyslog-8.2102.0.tar.gz && \
    tar -xvzf rsyslog-8.2102.0.tar.gz && \
    cd rsyslog-8.2102.0 && \
    ./configure --enable-omhttp --enable-imfile && \
    make && \
    make install

ARG ARCH
FROM balenalib/$ARCH-debian:buster-run-20221215
ARG ARCH
ENV PYTHON_VERSION=3.8.2

RUN install_packages \
    cron \
    ffmpeg \
    less \
    libfastjson4 \
    libestr0 \
    libcurl3-gnutls \
    libcairo2  \
    libpango-1.0-0  \
    libpangocairo-1.0-0  \
    libopenblas-base \
    libopenjp2-7 \
    nginx \
    openssh-client \
    vim \
    wget

COPY --from=build /usr/local/lib/rsyslog /usr/local/lib/rsyslog
COPY --from=build /usr/local/sbin/rsyslogd /usr/local/sbin

COPY rsyslog/rsyslog.conf /etc/rsyslog.conf
COPY rsyslog/rsyslog /etc/init.d/rsyslog

RUN chmod +x /etc/init.d/rsyslog && \
    mkdir -p /etc/rsyslog.d && \
    mkdir -p /var/spool/rsyslog && \
    useradd -U -G adm syslog && \
    echo "/usr/local/lib/rsyslog" >/etc/ld.so.conf.d/rsyslog-libs.conf && \
    ldconfig


RUN set -e \
    && wget  -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && tar -zxf Python-$PYTHON_VERSION.linux-$ARCH.tar.gz  --strip-components=1 \
    && rm Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && ldconfig \
    && pip3 install --upgrade pip wheel

COPY ./requirements.txt /tmp/
RUN pip3 install  \
        --trusted-host pypi-buster.motesque.com \
        --index-url http://pypi-buster.motesque.com:8181 \
        --extra-index-url https://pypi.org/simple \
        --no-cache-dir \
        --no-deps --find-links . -r /tmp/requirements.txt  \
        && pip3 check

# install microsoft contrib core fonts (Arial, Georgia etc). Needed for proper PDF reports
RUN install_packages cabextract xfonts-utils \
    && wget -nv https://nyc3-download-01.motesque.com/packages/ttf-mscorefonts-installer_3.8_all.deb \
    && dpkg -i ttf-mscorefonts-installer_3.8_all.deb \
    && rm ttf-mscorefonts-installer_3.8_all.deb

RUN dpkg-query -W -f '${binary:Package},${Version},${binary:Summary}\n' > /usr/local/lib/_stage_debian_packages.csv

