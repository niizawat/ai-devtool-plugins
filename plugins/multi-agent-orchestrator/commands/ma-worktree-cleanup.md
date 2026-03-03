---
name: ma-worktree-cleanup
description: 完了したWorkerのブランチをマージし、worktreeとブランチを片付ける手順。
---

# worktree 片付け（統合フェーズ）

Worker のハンドオフが出揃ったら、Integrator（または親エージェント）がブランチをマージして worktree を片付けます。

## Step 1: ベースブランチへのマージ

```bash
# ベースブランチへ移動
git checkout main   # または master / develop

# 各ワーカーブランチをマージ（競合がなければ --no-ff で履歴を残す）
git merge --no-ff worker/T1 -m "merge(T1): <タイトル>"
git merge --no-ff worker/T2 -m "merge(T2): <タイトル>"
git merge --no-ff worker/T3 -m "merge(T3): <タイトル>"
```

> **競合が発生した場合**: 競合ファイルを修正してから `git merge --continue` で続行してください。
> 判断が難しい競合は Root Planner に報告してください。

## Step 2: worktree の削除

```bash
git worktree remove ../REPO_NAME-worker-T1
git worktree remove ../REPO_NAME-worker-T2
git worktree remove ../REPO_NAME-worker-T3
```

## Step 3: ブランチの削除（統合済みの場合）

```bash
git branch -d worker/T1 worker/T2 worker/T3
```

リモートにプッシュしていた場合（必要なときだけ）:

```bash
git push origin --delete worker/T1 worker/T2 worker/T3
```

## Step 4: 後続フェーズへ

worktree の片付け完了後、QA フェーズへ移行します。
