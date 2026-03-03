---
name: ma-worktree-create
description: TaskSpecの並列タスク用に、ブランチ作成とgit worktree作成を行う手順テンプレ。
---

# worktree 作成（フォールバック）

通常は Cursor の **並列エージェント**機能を使い、Cursor が worktree を自動で作成・管理します。
このドキュメントは、並列エージェントを使えない場合の **フォールバック**として、手動で `git worktree` を作る手順です。

## 前提

- 起点ブランチは `origin/main`（または統合ブランチ）を推奨
- タスクIDは `T1` など

## 命名規則（推奨）

- `worktree.branch`: `worker/<TaskId>`（例: `worker/T1`）
- `worktree.path`: `../project-worker-<TaskId>`（例: `../project-worker-T1`）

## 作成（ブランチ + worktree を同時に作る）

```bash
git worktree add ../project-worker-T1 -b worker/T1 origin/main
```

## すでにブランチがある場合

```bash
git worktree add ../project-worker-T1 worker/T1
```

## Worker の作業開始

- `worktree.path` に移動して実装する
- ハンドオフは `commands/ma-handoff.md` のテンプレで提出する
