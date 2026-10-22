#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE="docker compose -f ${SCRIPT_DIR}/docker-compose.yml"

export HOST_UID="$(id -u)"
export HOST_GID="$(id -g)"
export WORKSPACE_DIR="$(pwd)"

# Свои папки создаём сами, иначе docker создаст их от root
mkdir -p "${SCRIPT_DIR}/agent-data" "${SCRIPT_DIR}/agent-config"

if [ $# -eq 0 ]; then
    set -- bash
fi

${COMPOSE} up -d proxy
${COMPOSE} build agent
${COMPOSE} run --rm agent "$@"
