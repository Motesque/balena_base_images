ARG ARCH
FROM balenalib/$ARCH-debian:buster-run
ARG ARCH
ENV PYTHON_VERSION=3.8.2


RUN install_packages \
    cron \
    less \
    libcairo2  \
    libpango-1.0-0  \
    libpangocairo-1.0-0  \
    libopenblas-base \
    libopenjp2-7 \
    nginx \
    openssh-client \
    vim \
    wget

# install microsoft contrib core fonts (Arial, Georgia etc). Needed for proper PDF reports
RUN install_packages cabextract xfonts-utils \
    && wget -nv http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8_all.deb \
    && dpkg -i ttf-mscorefonts-installer_3.8_all.deb \
    && rm ttf-mscorefonts-installer_3.8_all.deb

RUN ["/bin/bash", "-c", "if [ $ARCH != 'amd64' ]; then cross-build-start; fi"]
RUN set -e \
    && wget -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && tar -zxf Python-$PYTHON_VERSION.linux-$ARCH.tar.gz  --strip-components=1 \
    && rm Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
    && ldconfig \
    && pip3 install --upgrade pip wheel

COPY ./requirements.txt /tmp/
RUN pip3 install  \
        --trusted-host pypi.motesque.com \
        --index-url http://pypi.motesque.com:8181 \
        --extra-index-url https://pypi.org/simple \
        --no-cache-dir \
        --no-deps --find-links . -r /tmp/requirements.txt  \
        && pip3 check

RUN dpkg-query -W -f '${binary:Package},${Version},${binary:Summary}\n' > /usr/local/lib/_stage_debian_packages.csv
RUN ["/bin/bash", "-c", "if [ $ARCH != 'amd64' ]; then cross-build-end; fi"]