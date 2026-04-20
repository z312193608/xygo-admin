#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cleanup() {
  echo ""
  echo "正在停止前后端进程..."
  if [[ -n "${BACKEND_PID:-}" ]] && kill -0 "${BACKEND_PID}" 2>/dev/null; then
    kill "${BACKEND_PID}" 2>/dev/null || true
  fi
  if [[ -n "${FRONTEND_PID:-}" ]] && kill -0 "${FRONTEND_PID}" 2>/dev/null; then
    kill "${FRONTEND_PID}" 2>/dev/null || true
  fi
  wait || true
  echo "已退出。"
}

trap cleanup INT TERM EXIT

echo "启动后端: server/gf run main.go"
(
  cd "${ROOT_DIR}/server"
  gf run main.go
) &
BACKEND_PID=$!

echo "启动前端: web/pnpm dev"
(
  cd "${ROOT_DIR}/web"
  pnpm dev
) &
FRONTEND_PID=$!

echo "后端 PID: ${BACKEND_PID}"
echo "前端 PID: ${FRONTEND_PID}"
echo "按 Ctrl+C 可一键停止前后端。"

wait
