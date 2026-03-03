---
name: ma-handoff
description: Workerのハンドオフテンプレ。統合とQAのために必須。
---

# ハンドオフ（Worker → Integrator / Main Planner）

以下のテンプレを埋めて提出してください。空欄が多い場合は未完扱いになります。

## Summary

- 目的:
- 変更内容:

## Worktree（並列タスクの場合のみ）

- worktree_path: （例: `/Users/me/repos/myapp-worker-T1`、Single-task の場合は省略可）
- commit_hash: （実装完了後のコミットハッシュ、Integrator がマージに使用する）

## Files changed

- `path/to/file`

## Test plan

- 実行:
- 結果: pass/fail
- 補足（fail の場合）:

## Notes / Risks

- 影響範囲:
- 互換性/移行:
- 判断が必要な点:

## SkillCards evidence

TaskSpec で要求された `minimal_checks` の実行結果、または代替の証跡を記載してください。

- カード:
  - 証跡:
