FROM ubuntu:24.04

RUN apt-get -o Acquire::Retries=3 update && \
    DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=3 install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    bash \
    gnupg \
    jq \
    sudo \
    unzip \
    wget \
    zip \
    zsh \
    python3 \
    python3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN echo someone ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/someone

RUN groupadd -g 1010 someone && \
    useradd -u 1010 -g someone -s /bin/bash -m someone && \
    usermod -aG sudo someone

COPY --chown=someone:someone ./ /app/dotfiles

USER someone

WORKDIR /app/dotfiles

ENTRYPOINT ["tail", "-f", "/dev/null"]
