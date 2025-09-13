FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础编译工具
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    make \
    gcc \
    g++ \
    git \
    wget \
    curl \
    vim \
    zlib1g-dev \
    && apt-get clean

# 编译安装 OpenSSL 1.0.2u (安装到独立目录，不覆盖系统版本)
RUN cd /tmp && \
    wget https://www.openssl.org/source/openssl-1.0.2u.tar.gz && \
    tar -xzf openssl-1.0.2u.tar.gz && \
    cd openssl-1.0.2u && \
    ./config --prefix=/opt/openssl-1.0.2 --openssldir=/opt/openssl-1.0.2 shared zlib && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/openssl*



# 安装系统的 OpenSSL 1.1.x 和其他依赖
RUN apt-get update && \
    apt-get install -y \
    libssl-dev \
    libffi-dev \
    libcrypto++-dev \
    libcrypto++-utils \
    libmbedtls-dev \
    golang-go \
    openjdk-8-jdk \
    python \
    python-dev \
    python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置 Go 环境
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

RUN go get github.com/kudelskisecurity/cdf/cdf-lib || true


WORKDIR /cdf


CMD ["/bin/bash"]
