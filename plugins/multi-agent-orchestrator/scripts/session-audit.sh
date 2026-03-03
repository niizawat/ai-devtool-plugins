#!/usr/bin/env bash
set -euo pipefail

echo "[multi-agent-orchestrator] session audit"
echo "Reminder:"
echo "- Use TaskSpec with assigned_worker + skill_cards(max2)"
echo "- Require worker handoffs using commands/ma-handoff.md"
echo "- Run QA gates (commands/ma-qa.md) before release"
