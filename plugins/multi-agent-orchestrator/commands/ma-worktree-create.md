---
name: ma-worktree-create
description: 並列Workerのworktreeを作成する手順。並列タスクの標準的なセットアップフロー。
---

# worktree 作成（並列タスク開始前）

並列タスクでは **親エージェントが Worker を起動する前に** このコマンドを実行します。

## 前提確認

```bash
# 1. 現在のブランチを確認
git branch --show-current

# 2. コミットが1件もない場合（新規リポジトリ）は先に空コミットを作成
#    git worktree は少なくとも1件のコミットが必要
git log --oneline -1 2>/dev/null || git commit --allow-empty -m "chore: init"
```

## worktree の作成

```bash
# REPO_NAME はリポジトリのディレクトリ名（pwd の最後の要素）に合わせる
# タスク数（T1, T2, T3...）に合わせて繰り返す

git worktree add ../REPO_NAME-worker-T1 -b worker/T1
git worktree add ../REPO_NAME-worker-T2 -b worker/T2
git worktree add ../REPO_NAME-worker-T3 -b worker/T3

# 作成確認
git worktree list
```

## Worker への情報提供

worktree 作成後、各 Worker の起動プロンプトに以下を含めます：

```text
作業ディレクトリ（worktree）: /絶対パス/REPO_NAME-worker-T1
ブランチ: worker/T1

実装完了後に以下でコミットしてください：
  git -C /絶対パス/REPO_NAME-worker-T1 add .
  git -C /絶対パス/REPO_NAME-worker-T1 commit -m "feat(T1): <変更内容>"

コミット後にコミットハッシュをハンドオフの commit_hash フィールドに記載してください。
```

## worktree セットアップ（依存関係等が必要な場合）

プロジェクトに `.cursor/worktrees.json` がある場合は、その手順を worktree 作成後に実行します。

```bash
# 例: Node.js（pnpm）の場合
cd ../REPO_NAME-worker-T1
pnpm install
cp /元のリポジトリパス/.env .env
```
