FROM debian:trixie-slim

ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        jq \
        less \
        nano \
        procps \
        python3 \
        python3-venv \
        ripgrep \
        sudo \
        cmake \
        ninja-build \
        g++-aarch64-linux-gnu \
        libudev-dev \
        libpq-dev \
        libssl-dev \
        libboost-dev \
        libsystemd-dev \
        libgpiod-dev \
        nlohmann-json3-dev \
        libfmt-dev \
        libspdlog-dev \
        libprotobuf-dev \
        libpugixml-dev \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid "${GID}" agent \
    && useradd --uid "${UID}" --gid "${GID}" --create-home --shell /bin/bash agent \
    && mkdir -p /workspace \
    && chown agent:agent /workspace

# sudo без пароля для agent + сохранение proxy-переменных окружения
RUN echo 'agent ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/agent \
    && chmod 0440 /etc/sudoers.d/agent \
    && echo 'Defaults env_keep += "HTTP_PROXY HTTPS_PROXY http_proxy https_proxy NO_PROXY no_proxy"' > /etc/sudoers.d/proxy-env \
    && chmod 0440 /etc/sudoers.d/proxy-env

# opencode (AI coding agent) - ставим в /usr/local/bin, НЕ в /home/agent,
# т.к. том agent-home монтируется поверх /home/agent и скрывает его содержимое
RUN export HOME=/tmp/opencode-install \
    && curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path \
    && mv /tmp/opencode-install/.opencode/bin/opencode /usr/local/bin/opencode \
    && chmod 755 /usr/local/bin/opencode \
    && rm -rf /tmp/opencode-install

USER agent
WORKDIR /workspace
ENV HOME=/home/agent
