# ai-devtool-plugins

サブエージェント対応 AI ツール向けプラグインのモノレポです。
Cursor マーケットプレイス形式と [craftdesk](https://craftdesk.ai) の両方からインストールできます。

## 含まれるプラグイン

| プラグイン | 概要 |
| --- | --- |
| [`multi-agent-orchestrator`](./plugins/multi-agent-orchestrator/) | 計画 → 並列実装 → 統合 → QA ループを回すマルチエージェント開発フロー |

## インストール

利用したいプロジェクトのルートで実行してください。

```bash
craftdesk add https://github.com/niizawat/ai-devtool-plugins/tree/main/plugins/multi-agent-orchestrator
craftdesk install
```

## 構成

```
plugins/
└── multi-agent-orchestrator/   # プラグイン本体
    ├── .claude-plugin/         # craftdesk 向けマニフェスト
    ├── .cursor-plugin/         # Cursor 向けマニフェスト
    ├── agents/
    ├── commands/
    ├── rules/
    └── hooks/
.cursor-plugin/
└── marketplace.json            # Cursor マーケットプレイス定義
```

## ライセンス

MIT
