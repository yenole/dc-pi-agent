FROM node:22-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    npm_config_update_notifier=false

# Pi 常用的终端与开发工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    wget \
    git \
    openssh-client \
    ripgrep \
    fd-find \
    fzf \
    jq \
    less \
    tree \
    vim-tiny \
    procps \
    build-essential \
    python3 \
    python3-pip \
    unzip \
    zip \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# 安装 Pi coding agent CLI
RUN npm install --global @earendil-works/pi-coding-agent

# 以非 root 用户运行；启动时按需安装 pi-web-ui
USER node

WORKDIR /workspace

COPY --chown=node:node docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
