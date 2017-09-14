FROM ubuntu:16.04
MAINTAINER Juanjo Alvarez <gorthol@protonmail.com>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e && \
    echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main" \
    > /etc/apt/sources.list.d/bitcoin.list

RUN apt-get update
RUN apt-get install -y wget build-essential libtool autotools-dev automake \
    pkg-config libssl-dev libevent-dev bsdmainutils python3 libzmq3-dev \
    libdb4.8-dev libdb4.8++-dev libboost-system-dev libboost-filesystem-dev \
    libboost-chrono-dev libboost-program-options-dev libboost-test-dev \
    libboost-thread-dev

RUN mkdir /bitcoin
ENV HOME /bitcoin
RUN cd /bitcoin &&\
    wget https://github.com/bitcoin/bitcoin/archive/v0.15.0.tar.gz &&\
    tar -zxvf v0.15.0.tar.gz

RUN cd /bitcoin/bitcoin-0.15.0 && \
    ./autogen.sh && \
    ./configure --without-gui --without-miniupnpc && \
    make

RUN cd /bitcoin/bitcoin-0.15.0 && make install

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

VOLUME ["/bitcoin"]
EXPOSE 8332 8333
WORKDIR /bitcoin

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
