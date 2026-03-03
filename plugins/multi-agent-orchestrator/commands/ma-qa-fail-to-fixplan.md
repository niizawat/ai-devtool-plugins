---
name: ma-qa-fail-to-fixplan
description: QAのBlockersを修正計画（Single-taskまたは3〜5並列）に変換し、領域Workerとスキルカードを割り当てる。
---

# QA Fail → 修正計画

QA の `blockers` を入力に、修正タスクへ落とします。

## 入力

- QAResult（Fail）
- 既存の TaskSpec / IntegrationReport

## 出力（Root Planner が返す）

- Blockers を 1〜3 個に絞り、修正タスクに変換する
- 小さければ Single-task、そうでなければ 3〜5 の並列にする
- 各修正タスクに `assigned_worker` と `skill_cards`（最大 2）を付与する

出力フォーマットは `agents/root-planner.md` に従ってください。
