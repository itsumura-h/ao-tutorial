FROM node:22.6.0-bookworm-slim

RUN apt update && apt upgrade -y
RUN apt install -y \
  git \
  curl

WORKDIR /project/src
# aos
RUN npm i -g https://get_ao.g8way.io
# pnpm
RUN curl -fsSL https://get.pnpm.io/install.sh | bash -
