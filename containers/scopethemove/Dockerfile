#-------------------------
# Build Stage
#-------------------------
ARG ARCH
FROM balenalib/$ARCH-debian:buster-build-20200502 as build
ARG ARCH
ENV PYTHON_VERSION=3.8.2

RUN ["/bin/bash", "-c", "if [ $ARCH != 'amd64' ]; then cross-build-start; fi"]
# Compile wiring library for i2c led control
RUN mkdir -p /usr/tmp && cd /usr/tmp \
    && wget  -nv https://download.motesque.com/wiringPi-96344ff.tar.gz \
    && tar xfz wiringPi-96344ff.tar.gz \
    && cd wiringPi-96344ff/wiringPi \
    && mkdir -p /wiring/usr/lib \
    && DESTDIR=/wiring/usr make \
    && DESTDIR=/wiring/usr make install
RUN ["/bin/bash", "-c", "if [ $ARCH != 'amd64' ]; then cross-build-end; fi"]

#-------------------------
# Runtime Stage
#-------------------------
FROM balenalib/$ARCH-debian:buster-run-20200502
ARG ARCH
ENV PYTHON_VERSION=3.8.2

COPY --from=build /wiring/ /

RUN apt-get update -y
RUN apt-get upgrade -y

RUN install_packages \
     binutils \
     cron \
     curl \
     dbus \
     dfu-util \
     exfat-fuse \
     exfat-utils \
     ffmpeg \
     gfortran \
     htop \
     less  \
     libcairo2  \
     libgfortran5 \
     libhdf5-103 \
     libopenjp2-7 \
     libopenblas-base \
     libpango-1.0-0  \
     libpangocairo-1.0-0  \
     net-tools \
     netcat \
     nfs-common \
     ntfs-3g \
     ntp \
     openssl  \
     openssh-client \
     pkg-config \
     usbutils \
     vim \
     wget \
     zlib1g

# install microsoft contrib core fonts (Arial, Georgia etc). Needed for proper PDF reports
RUN install_packages cabextract xfonts-utils \
    && wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8_all.deb \
    && dpkg -i ttf-mscorefonts-installer_3.8_all.deb \
    && rm ttf-mscorefonts-installer_3.8_all.deb

RUN ["/bin/bash", "-c", "if [ $ARCH != 'amd64' ]; then cross-build-start; fi"]

# install python 3.x for this platform
RUN set -e \
    && wget -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && tar -zxf Python-$PYTHON_VERSION.linux-$ARCH.tar.gz  --strip-components=1 \
    && rm Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && ldconfig \
    && pip3 install --upgrade pip wheel


# we need to particle-cli to update photon bootloaders. We are using a zipped version since the offical
# installer has many problems. We also need to fool the autoupdate feature
RUN if [ "$(dpkg --print-architecture)" = "armhf" ]; then cd /root/ \
    && wget https://download.motesque.com/particle_cli_motesque_worked.tar.gz \
    && tar -xzf particle_cli_motesque_worked.tar.gz --strip-components=1 \
    && rm particle_cli_motesque_worked.tar.gz \
    && chmod +x /root/bin/particle \
    && touch -a -m -t 203101180813.09 /root/.particle/autoupdate ; fi


# install all neccessary python packages. --no-deps ensures every version is pinned
# ...but Cython needs to be installed first.
COPY ./requirements.txt  /tmp/
RUN pip3 install --no-deps \
        --trusted-host pypi-buster.motesque.com \
        --index-url http://pypi-buster.motesque.com:8181 \
        --extra-index-url https://pypi.org/simple \
        Cython==0.29.21 \
        numpy==1.19.1

RUN pip3 install  \
        --trusted-host pypi-buster.motesque.com \
        --index-url http://pypi-buster.motesque.com:8181 \
        --extra-index-url https://pypi.org/simple \
        --no-cache-dir \
        --no-deps \
        --find-links . -r /tmp/requirements.txt
RUN pip3 check
RUN ["/bin/bash", "-c", "if [ $ARCH != 'amd64' ]; then cross-build-end; fi"]


# 2nd tier dependecies
RUN install_packages \
       nginx \
       lockfile-progs \
       rsyslog  \
       rsyslog-gnutls 

