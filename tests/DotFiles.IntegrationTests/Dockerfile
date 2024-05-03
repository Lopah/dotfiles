FROM ubuntu:latest

COPY ./ /app/dotfiles

RUN apt-get update && apt-get install -y \
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
    python3-dev  

RUN echo someone ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/someone

RUN groupadd -g 1010 someone && \
    useradd -u 1010 -g someone -s /bin/bash -m someone && \
    usermod -aG sudo someone && \
    chown -R someone:someone /app/dotfiles

USER someone

WORKDIR /app/dotfiles

ENTRYPOINT ["tail", "-f", "/dev/null"]