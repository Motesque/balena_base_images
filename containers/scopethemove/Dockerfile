ARG ARCH
FROM balenalib/$ARCH-debian:stretch-build-20190215 as build
ARG ARCH
ENV PYTHON_VERSION=3.6.8

RUN [ "if [ $ARCH != "amd64" ]; then cross-build-start; fi" ]

RUN mkdir -p /usr/tmp && cd /usr/tmp \
    && wget -nv https://download.motesque.com/wiringPi-96344ff.tar.gz \
    && tar xfz wiringPi-96344ff.tar.gz \
    && cd wiringPi-96344ff/wiringPi \
    && mkdir -p /wiring/usr/lib \
    && DESTDIR=/wiring/usr make \
    && DESTDIR=/wiring/usr make install

RUN set -e \
    && wget -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && tar -zxf Python-$PYTHON_VERSION.linux-$ARCH.tar.gz  --strip-components=1 \
    && rm Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && ldconfig \
    && pip3 install --upgrade pip

RUN pip3 install wheel && pip3 wheel --no-deps -w /tmp/wheels RPi.GPIO==0.6.5

RUN [ "if [ $ARCH != "amd64" ]; then cross-build-end; fi" ]


#-------------------------
# Runtime Image
#-------------------------
FROM balenalib/$ARCH-debian:stretch-run-20190215
ARG ARCH
ENV PYTHON_VERSION=3.6.8

COPY --from=build /wiring/ /
COPY --from=build /tmp/wheels /tmp/wheels

RUN [ "if [ $ARCH != "amd64" ]; then cross-build-start; fi" ]

RUN install_packages \
     cron \
     curl \
     dbus \
     ffmpeg \
     htop \
     less  \
     libcairo2  \
     libopenjp2-7 \
     libpango-1.0-0  \
     libpangocairo-1.0-0  \
     net-tools \
     netcat \
     nfs-common \
     ntp \
     openssl  \
     openssh-client \
     usbutils \
     vim \
     wget \
     zlib1g

# install microsoft contrib core fonts (Arial, Georgia etc)
RUN install_packages cabextract xfonts-utils \
    && wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb \
    && dpkg -i ttf-mscorefonts-installer_3.6_all.deb \
    && rm ttf-mscorefonts-installer_3.6_all.deb

RUN set -e \
    && wget -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && tar -zxf Python-$PYTHON_VERSION.linux-$ARCH.tar.gz  --strip-components=1 \
    && rm Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && ldconfig \
    && pip3 install --upgrade pip wheel

RUN pip3 install --no-deps /tmp/wheels/*.whl && rm -rf /tmp/wheels/

COPY ./requirements.txt ./requirements-crossbar.txt /tmp/
RUN pip3 install  \
        --trusted-host pypi.motesque.com \
        --index-url http://pypi.motesque.com:8181 \
        --extra-index-url https://pypi.org/simple \
        --no-cache-dir \
        --no-deps --find-links . -r /tmp/requirements.txt  \
        && pip3 check

RUN [ "if [ $ARCH != "amd64" ]; then cross-build-end; fi" ]

# 2nd tier dependecies
RUN install_packages \
       dfu-util \
       nginx \
       lockfile-progs \
       rsyslog  \
       rsyslog-gnutls


