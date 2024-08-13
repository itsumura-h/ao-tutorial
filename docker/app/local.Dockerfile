FROM ubuntu:24.04

# prevent timezone dialogue
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y
RUN apt install -y \
  git \
  curl \
  gcc \
  g++ \
  xz-utils \
  ca-certificates \
  libpcre3-dev \
  unzip \
  make \
  clang \
  cmake 

WORKDIR /project/src
# nodejs
WORKDIR /root
# https://nodejs.org/en/download/prebuilt-binaries
RUN curl -OL https://nodejs.org/dist/v20.16.0/node-v20.16.0-linux-x64.tar.xz
RUN tar -xvf node-v20.16.0-linux-x64.tar.xz
RUN rm node-v20.16.0-linux-x64.tar.xz
RUN mv node-v20.16.0-linux-x64 .node
ENV PATH /root/.node/bin:$PATH
# aos
RUN npm i -g https://get_ao.g8way.io
# pnpm
RUN curl -fsSL https://get.pnpm.io/install.sh | bash -
# nim
RUN curl https://nim-lang.org/choosenim/init.sh -o init.sh
RUN git config --global --add safe.directory ./
RUN sh init.sh -y
RUN rm -f init.sh
ENV PATH /root/.nimble/bin:$PATH
# python
RUN apt install -y python3
# emcc
WORKDIR /root
RUN git clone https://github.com/emscripten-core/emsdk.git /root/.emsdk
WORKDIR /root/.emsdk
RUN ./emsdk install latest
RUN ./emsdk activate latest
RUN echo 'source "/root/.emsdk/emsdk_env.sh"' >> $HOME/.bashrc
# ninja
WORKDIR /root
RUN curl -OL https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-linux.zip
RUN unzip ninja-linux.zip
RUN rm ninja-linux.zip
RUN mv ninja /usr/local/bin
# webt
WORKDIR /root
RUN git clone --recursive https://github.com/WebAssembly/wabt .wabt
WORKDIR /root/.wabt
RUN git submodule update --init
RUN make
RUN make install
