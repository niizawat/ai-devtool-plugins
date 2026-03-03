---
name: ma-parallel-agents
description: Cursorの並列エージェント機能を使って、Workerを3〜5並列で実行し、Applyで取り込む運用テンプレ。
---

# 並列エージェント（3〜5並列）

並列タスクは Cursor の **並列エージェント**機能で実行します。各エージェントは専用 worktree 上で動作し、互いに干渉せずに編集・ビルド・テストを行えます。

## Root Planner の責務

- TaskSpec を発行する（Mode: parallel）
- 各タスクに `assigned_worker` と `skill_cards`（最大2）を付与する
- **各Workerへの作業指示プロンプト**を完成形で提示し、可能であれば Root Planner 自身が 3〜5 並列で起動する
- Root Planner が起動できない場合（サブエージェント入れ子制限など）は、メインのAgent（親）が起動できるようにプロンプトを提示する

## ユーザーの実行手順（概要）

1. Root Planner が Worker を 3〜5 並列で起動する（起動できない場合は、メインのAgent（親）が提示された Worker プロンプトを並列エージェントとして起動する）
2. 各カードで変更内容を確認する
3. 必要なカードから順に **Apply** でプライマリ作業ツリーへ取り込む（同一実行内で複数回 Apply する場合は、Cursor の案内に従う）
4. 取り込み後、統合と QA を実行する

## Apply の補足

- Apply は、worktree 側の変更をプライマリ作業ツリーに取り込む操作です
- 複数カードの結果を取り込む際は、競合が起きた場合に Cursor の UI で merge を選ぶことがあります

## worktree セットアップ（任意）

依存関係のインストールや環境ファイルのコピーなど、worktree 作成時に必要な手順がある場合は、プロジェクト側に `.cursor/worktrees.json` を用意します。

- Node.js の例（npmではなくpnpm）:

```json
{
  "setup-worktree": [
    "pnpm install",
    "cp $ROOT_WORKTREE_PATH/.env .env"
  ]
}
```
