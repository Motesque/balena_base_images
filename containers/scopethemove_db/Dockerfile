ARG ARCH
FROM balenalib/$ARCH-debian:buster-build-20221215 as build
ARG ARCH

RUN install_packages \
    autotools-dev \
    debhelper \
    devscripts \
    erlang \
    git \
    libnspr4-dev \
    lsb-release  \
    pkg-kde-tools  \
    zip

## NOTES:
## CouchDB 2.x on aarch64 NEEDS patches for SpiderMonkey 1.8.5. The official debian packages won't work and the
## couchdb crashes on runtime (when creating views)
## These github issues talk about it. The remedy is to use couchdb-pkg to build the patched version before compiling
## CouchDB.
##   - https://github.com/apache/couchdb/issues/1333
##   - https://github.com/apache/couchdb/issues/1832
##   - https://github.com/apache/couchdb-pkg
##   - https://github.com/apache/couchdb-docker/issues/54

# compile patched CouchDB SpiderMonkey
RUN cd  /tmp \
    && git clone https://github.com/apache/couchdb-pkg.git \
    && cd couchdb-pkg \
    && make couch-js-debs PLATFORM=$(lsb_release -cs) > make-couch-js-debs.log 2> make-couch-js-debs-error.log

# compile CouchDB 2.x
RUN cd /tmp/ \
    && apt-get install -f /tmp/couchdb-pkg/js/couch-libmozjs185-1.0_1.8.5-1.0.0*.deb \
    && apt-get install -f /tmp/couchdb-pkg/js/couch-libmozjs185-dev_1.8.5-1.0.0*.deb \
    && wget https://nyc3-download-01.motesque.com/packages/apache-couchdb-2.3.0.tar.gz \
    && tar -zxvf apache-couchdb-2.3.0.tar.gz \
    && cd apache-couchdb-2.3.0 \
    && ./configure --disable-docs \
    && make release -j4  > make-couchdb.log 2> make-couchdb-error.log

# Compile wiring library for i2c led control
RUN mkdir -p /usr/tmp && cd /usr/tmp \
    && wget -nv https://nyc3-download-01.motesque.com/packages/wiringPi-96344ff.tar.gz \
    && tar xfz wiringPi-96344ff.tar.gz \
    && cd wiringPi-96344ff/wiringPi \
    && mkdir -p /wiring/usr/lib \
    && DESTDIR=/wiring/usr make \
    && DESTDIR=/wiring/usr make install

#-------------------------
# Runtime Image
#-------------------------
FROM balenalib/$ARCH-debian:buster-run-20221215
ARG ARCH
ENV PYTHON_VERSION=3.8.2

COPY --from=build /wiring/ /

RUN install_packages wget libnspr4 icu-devtools

COPY --from=build  /tmp/apache-couchdb-2.3.0/rel/couchdb /usr/local/lib/couchdb
COPY --from=build  /tmp/couchdb-pkg/js/couch-libmozjs185-1.0_1.8.5-1.0.0*.deb /usr/local/lib/couchdb/
RUN apt-get install -f /usr/local/lib/couchdb/couch-libmozjs185-1.0_1.8.5-1.0.0*.deb

#RUN ["/bin/bash", "-c", "if [ $ARCH != 'amd64' ]; then cross-build-start; fi"]

RUN set -e \
    && wget -nv https://nyc3-download-01.motesque.com/packages/Python-$PYTHON_VERSION.linux-$ARCH.tar.gz \
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