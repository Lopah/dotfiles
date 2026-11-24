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

# Ubuntu's neovim package (0.9) is older than VimTeX's minimum (0.12.4).
ARG NVIM_VERSION=0.12.6
RUN arch="$(uname -m)" && \
    if [ "$arch" = aarch64 ]; then arch=arm64; fi && \
    curl -fsSL --retry 3 "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-${arch}.tar.gz" \
    | tar -xz -C /opt && \
    ln -s "/opt/nvim-linux-${arch}/bin/nvim" /usr/local/bin/nvim

RUN echo someone ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/someone

RUN groupadd -g 1010 someone && \
    useradd -u 1010 -g someone -s /bin/bash -m someone && \
    usermod -aG sudo someone

COPY --chown=someone:someone ./ /app/dotfiles

USER someone

WORKDIR /app/dotfiles

ENTRYPOINT ["tail", "-f", "/dev/null"]
