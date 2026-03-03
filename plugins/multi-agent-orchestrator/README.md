# multi-agent-orchestrator

サブエージェント対応環境を前提にした「計画 → 並列実装 → 統合 → QA → リリース」のマルチエージェント開発フローを、再現性のある運用として提供するプラグインです。

## インストール

利用したいプロジェクトのルートで以下のコマンドを実行してください。

```bash
# craftdesk.json を初期化（初回のみ）
pnpm dlx craftdesk init

# プラグインを依存に追加（モノレポのサブディレクトリを直接指定）
pnpm dlx craftdesk add https://github.com/niizawat/ai-devtool-plugins/tree/main/plugins/multi-agent-orchestrator

# インストール実行（.claude/plugins/ 以下に展開される）
pnpm dlx craftdesk install
```

### 反映確認

- ホストを再起動（またはウィンドウのリロード）して、利用可能なエージェント/コマンド一覧に `main-planner` などが出ることを確認してください。

### アンインストール

`craftdesk.json` の `dependencies` から `multi-agent-orchestrator` を削除し、再度 `craftdesk install` を実行してください。

## できること

- Main Planner がタスクを作成し、必要なら 3〜5 タスクに分割して並列化
- 4種類の領域 Worker（frontend / backend / mobile / infra）に割り当て
- Integrator がハンドオフを統合し、QA が品質ゲートで合否判定
- QA が NG の場合、Main Planner に戻して修正ループ（Single-task または 3〜5 の修正タスク）

## コンセプト

- 小スコープは Single-task を優先して高速に処理する
- 並列化する場合のみ 3〜5 に分割してスループットを上げる
- タスク仕様（TaskSpec）に `AssignedWorker` と `SkillCards`（最大 2）を必須化してタスク割り当て漏れを防ぐ
- QA は「合否」「Blockers（最大 3）」「次アクション」を固定フォーマットで返す
- 要件定義/設計/参考情報のドキュメント場所（ファイルパス/URL）は、ユーザーが Main Planner に提示する前提。未提示なら Main Planner が質問して確認する

## 含まれるコンポーネント

- `agents/`: Main Planner / Sub Planner / Integrator / QA / 領域 Worker
- `rules/`: 運用プロトコル、QA ゲート、安全なシェル実行のガードレール
- `commands/`: 計画、ハンドオフ、統合、QA、NG→修正計画の定型プロンプト
- `hooks/`: 最小の安全柵（任意）

## 使い方（最短）

以下のように`main-planner`サブエージェントを呼び出して実装計画を作成させ、内容に承認すると実装開始します。

```text
/main-planner docs/以下のドキュメントを確認して、実装計画を作成してください
```
