---
name: ma-worktree-cleanup
description: 完了したタスクのworktreeディレクトリとブランチを片付ける手順テンプレ。
---

# worktree 片付け（タスク完了後）

タスク完了後、不要になった worktree とブランチを片付けます。

## 削除（worktree）

```bash
git worktree remove ../project-worker-T1
```

## 削除（ブランチ）

統合済みで不要になった場合:

```bash
git branch -d worker/T1
```

リモート運用している場合（必要なときだけ）:

```bash
git push origin --delete worker/T1
```
