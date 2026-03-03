---
name: ma-parallel-agents
description: git worktreeを使って、Workerを3〜5並列で実行する運用テンプレ。ホストの UI に依存しない。
---

# 並列エージェント（3〜5並列）

並列タスクは **git worktree** を使って実行します。
各 Worker は専用の worktree とブランチ上で作業するため、互いに干渉せず並列で実装・コミットできます。

## 全体フロー

```
親エージェント
  ├─ [Step 0] worktree 作成（Worker 起動前）
  ├─ [Step 1] Worker を並列で起動（Task tool）
  │    ├─ Worker T1 → worktree T1 で実装 → コミット → ハンドオフ提出
  │    ├─ Worker T2 → worktree T2 で実装 → コミット → ハンドオフ提出
  │    └─ Worker T3 → ...
  └─ [Step 2] Integrator がブランチをマージ → worktree を片付け → QA
```

## Step 0: worktree 作成（Worker 起動前に必ず実行）

`commands/ma-worktree-create.md` の手順に従い、Worker ごとに worktree を作成します。

```bash
# コミットが1件もない場合は先に空コミットを作成
git log --oneline -1 2>/dev/null || git commit --allow-empty -m "chore: init"

# タスク数に合わせて繰り返す（REPO_NAME はリポジトリのディレクトリ名）
git worktree add ../REPO_NAME-worker-T1 -b worker/T1
git worktree add ../REPO_NAME-worker-T2 -b worker/T2
git worktree add ../REPO_NAME-worker-T3 -b worker/T3
```

## Step 1: Worker の起動

Main Planner は各タスクの「完成形の作業指示プロンプト」を出力し、親エージェントが Task tool で並列起動します。

各 Worker への指示に必ず含めること：

- 担当 TaskSpec（`task_id`、スコープ、受け入れ条件、最小チェック）
- **作業する worktree の絶対パス**（例: `/Users/me/repos/myapp-worker-T1`）
- 実装完了後に `git add . && git commit -m "..."` でコミットする指示
- ハンドオフは `commands/ma-handoff.md` テンプレで提出（`worktree_path` と `commit_hash` を記載）

## Step 2: 統合と後片付け

Worker のハンドオフが出揃ったら、`commands/ma-worktree-cleanup.md` の手順でブランチをマージし、worktree を削除します。

## worktree セットアップ（依存関係インストール等が必要な場合）

プロジェクト側に worktree セットアップ設定（例: `.cursor/worktrees.json` や `.claude/worktrees.json`）を用意すると、worktree 作成後のセットアップを定義できます。

- Node.js の例（pnpm）:

```json
{
  "setup-worktree": [
    "pnpm install",
    "cp $ROOT_WORKTREE_PATH/.env .env"
  ]
}
```
