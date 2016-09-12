FROM ubuntu:16.04
MAINTAINER Terence Lee "hone02@gmail.com"

RUN apt-get update && apt-get upgrade
RUN apt-get install -y \
    build-essential \
    ca-cacert \
    clang \
    curl \
    git
RUN apt-get clean

RUN mkdir -p /.cargo/
COPY cargo_config /.cargo/config

RUN groupadd -g 1000 rust && \
    useradd -u 1000 -g 1000 -m rust

RUN mkdir -p /opt/osxcross && \
    chown rust:rust /opt/osxcross/

USER rust
WORKDIR /home/rust/code

ENV PATH $PATH:/home/rust/.cargo/bin/:/opt/osxcross/bin

RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    git clone https://github.com/tpoechtrager/osxcross.git
COPY MacOSX10.11.sdk.tar.bz2 /tmp/osxcross/tarballs/
RUN echo "\n" | OSX_VERSION_MIN=10.7 bash -c '/tmp/osxcross/build.sh'
RUN mkdir -p /opt/osxcross && mv /tmp/osxcross/target/* /opt/osxcross
RUN rm -rf /tmp/osxcross

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    rustup default stable && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup target add x86_64-apple-darwin && \
    rustup target add x86_64-pc-windows-gnu

CMD cargo build --target=x86_64-unknown-linux-musl --release && \
    cargo build --target=x86_64-apple-darwin --release
