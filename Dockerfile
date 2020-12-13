FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libmicrohttpd-dev libssl-dev cmake build-essential git wget libuv1-dev && \
    apt-get install -y gcc-7 g++-7 && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2 && \
        tar xvfj boost_1_75_0.tar.bz2 && rm boost_1_75_0.tar.bz2 && \
        cd boost_1_75_0 && \
        ./bootstrap.sh --with-libraries=system && \
        ./b2 --toolset=gcc-7 && ./b2 link=static runtime-link=static install --toolset=gcc-7 && \
        git clone https://github.com/Bendr0id/xmrigCC.git && \
	cd xmrigCC && cmake . -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 -DWITH_CC_SERVER=OFF \
        -DWITH_TLS=OFF -DWITH_HTTPD=OFF -DWITH_HWLOC=OFF -DBOOST_ROOT=~/xmrigCC/boost_1_75_0  &&  make
	
ENTRYPOINT  ["/boost_1_75_0/xmrigCC/xmrigDaemon","--config=/tmp/config.json"]
