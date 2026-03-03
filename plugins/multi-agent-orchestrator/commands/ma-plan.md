---
name: ma-plan
description: Root Plannerが実装計画（文章）を作成し、承認後にTaskSpec作成→委譲→QAまで回す。
---

# マルチエージェント計画（2段階）

## 入力（ユーザーが与える）

- 目的
- 制約（技術、期限、やらないこと）
- 期待する成果（リリース基準）
- 要件定義/設計/参考情報の場所（ファイルパス/URL）

## 出力（Root Planner が返す）

次の 2 段階で出力してください。

### 1) 実装計画（文章）

- ユーザーが読みやすい文章（Markdownの箇条書き）で書く
- Single-task か Parallel（3〜5）かの判断理由を含める
- Parallelの場合は、領域Worker（frontend/backend/mobile/infra）への分割方針を含める
- リスクと検証方針（最小チェックの考え方）を含める
- 最後に「この計画で進めてよいか」をユーザーに確認する

### 2) 実行用の出力（承認後）

- TaskSpec YAML（Mode: single または Mode: parallel）
- Mode: parallel の場合は、3〜5個のWorker向け作業指示プロンプト（完成形）と、並列エージェント→Apply→統合→QAの手順
- QA Fail の場合の修正ループ（修正タスクと修正指示プロンプトの出し方）

### 判断基準

- Single-task: 変更が小さく、単一 Worker で安全に完結できる
- Parallel: レイヤ跨ぎ/不確実性/作業量が大きく、並列化の価値がある

### TaskSpec（テンプレ）

- `assigned_worker` は `frontend|backend|mobile|infra`
- `skill_cards` は最大 2
- `acceptance_criteria` は yes/no で判定可能な短文を最大 3
- `minimal_checks` は `<PROJECT_DEFINED>` 可

Root Planner は `agents/root-planner.md` のフォーマットに従って出力してください。

ユーザーが要件定義/設計/参考情報の場所を指定していない場合は、計画を作る前に質問して確認してください。

補足:

- 並列化（3〜5）の場合、各 Worker は空のコンテキストから開始します。Root Planner は各Worker向けに「必要情報をすべて含む完成形の作業指示プロンプト」を提示してください。
- Root Planner は「ユーザーが個別に Worker へ指示を考えない」前提で、作業指示プロンプト（3〜5）を完成形で提示してください。
