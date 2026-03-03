---
name: ma-integrate
description: 複数のWorkerハンドオフを統合し、QAに渡せる統合状態にまとめるためのチェックリスト。
---

# 統合（Integrator / Main Planner）

複数のハンドオフを統合して、QA に渡せる状態にします。

## 入力

- Worker ハンドオフ（`commands/ma-handoff.md` 形式）
- Main Planner の TaskSpec

## チェックリスト

- 受け入れ条件に照らして、各ハンドオフが目的どおりか確認
- 変更が競合する箇所がないか確認（競合がある場合は Main Planner に判断を求める）
- `SkillCards minimal_checks` の証跡が揃っているか確認（未実行なら理由と代替）
- 重大退行の可能性がある変更を列挙し、QA の Focus として渡す
- リリースノート（ドラフト）を 1〜5 行で用意

## 出力

Integrator は `agents/integrator.md` の `IntegrationReport` フォーマットで出力してください。
