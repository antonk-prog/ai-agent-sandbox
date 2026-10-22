FROM debian:trixie-slim

ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid "${GID}" agent \
    && useradd --uid "${UID}" --gid "${GID}" --create-home --shell /bin/bash agent \
    && mkdir -p /workspace \
    && chown agent:agent /workspace

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
