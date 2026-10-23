#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
C="docker compose -f ${DIR}/docker-compose.yml"

export BUILD_UID="$(id -u)" BUILD_GID="$(id -g)"
export HOST_UID="$(id -u)" HOST_GID="$(id -g)"
export WORKSPACE_DIR="$(pwd)"

mkdir -p "${DIR}/agent-data" "${DIR}/agent-config"

$C up -d proxy
$C build agent
$C run --rm agent bash
