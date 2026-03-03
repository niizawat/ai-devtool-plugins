---
name: ma-qa
description: QAゲートを実行し、pass/fail、Blockers（最大3）、具体的な次の修正計画を返す。
---

# QA（合否判定）

統合状態に対して QA ゲートを実行し、合否と次アクションを返します。

## 参照

- `rules/qa-gates.mdc`
- Root Planner の TaskSpec
- IntegrationReport

## 出力

QA は `agents/qa.md` の `QAResult` フォーマットで出力してください。

制約:

- `blockers` は最大 3
- `next_fix_plan` は `mode: single` または `mode: parallel`（parallel の場合は 3〜5）
- 修正タスクにも `assigned_worker` と `skill_cards`（最大 2）を付与する
