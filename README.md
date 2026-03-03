# ai-devtool-plugins

サブエージェント対応 AI ツール向けプラグインのモノレポです。
Claude Code のプラグインマーケットプレイスからインストールできます。

## 含まれるプラグイン

| プラグイン | 概要 |
| --- | --- |
| [`multi-agent-orchestrator`](./plugins/multi-agent-orchestrator/) | 計画 → 並列実装 → 統合 → QA ループを回すマルチエージェント開発フロー |

## インストール

Claude Code 内でマーケットプレイスを追加し、プラグインをインストールします。

```
/plugin marketplace add niizawat/ai-devtool-plugins
/plugin install multi-agent-orchestrator@ai-devtool-plugins
```

詳細は各プラグインの README を参照してください。

## 構成

```
plugins/
└── multi-agent-orchestrator/   # プラグイン本体
    ├── .claude-plugin/         # Claude Code マーケットプレイス向けマニフェスト
    ├── agents/
    ├── commands/
    ├── rules/
    └── hooks/
.claude-plugin/
└── marketplace.json            # マーケットプレイス定義
```

## ライセンス

MIT
