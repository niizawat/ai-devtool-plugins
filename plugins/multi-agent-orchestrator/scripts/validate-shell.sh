#!/usr/bin/env bash
set -euo pipefail

command_text="${*:-}"

if [[ -z "${command_text}" ]]; then
  if [[ -p /dev/stdin ]]; then
    command_text="$(cat)"
  fi
fi

if [[ -z "${command_text}" ]]; then
  echo "[multi-agent-orchestrator] validate-shell: no command text provided; allow"
  exit 0
fi

deny_patterns=(
  "rm[[:space:]]+-rf[[:space:]]+/"
  "git[[:space:]]+push[[:space:]]+--force"
  "git[[:space:]]+reset[[:space:]]+--hard"
)

for pat in "${deny_patterns[@]}"; do
  if [[ "${command_text}" =~ ${pat} ]]; then
    echo "[multi-agent-orchestrator] validate-shell: blocked unsafe command"
    echo "Command: ${command_text}"
    exit 1
  fi
done

exit 0
