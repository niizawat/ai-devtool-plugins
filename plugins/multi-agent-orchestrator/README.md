# multi-agent-orchestrator

Cursor SubAgent を前提にした「計画 → 並列実装 → 統合 → QA → リリース」のマルチエージェント開発フローを、再現性のある運用として提供するプラグインです。

## インストール

このリポジトリ（`/Users/tadashi.niizawa/workspaces/project-plugin`）で開発しつつ、Cursor からはローカルプラグインとして参照できるようにします。

### 推奨: シンボリックリンクで有効化（macOS/Linux）

```bash
mkdir -p "$HOME/.cursor/plugins/local"
ln -s "/Users/tadashi.niizawa/workspaces/project-plugin/plugins/multi-agent-orchestrator" \
  "$HOME/.cursor/plugins/local/multi-agent-orchestrator"
```

### 代替: コピーで有効化

```bash
mkdir -p "$HOME/.cursor/plugins/local"
cp -R "/Users/tadashi.niizawa/workspaces/project-plugin/plugins/multi-agent-orchestrator" \
  "$HOME/.cursor/plugins/local/multi-agent-orchestrator"
```

### 反映確認

- Cursor を再起動（またはウィンドウのリロード）して、利用可能なエージェント/コマンド一覧に `root-planner` などが出ることを確認してください。

### アンインストール

```bash
rm -rf "$HOME/.cursor/plugins/local/multi-agent-orchestrator"
```

## できること

- Root Planner がタスクを作成し、必要なら 3〜5 タスクに分割して並列化
- 4種類の領域 Worker（frontend / backend / mobile / infra）に割り当て
- Integrator がハンドオフを統合し、QA が品質ゲートで合否判定
- QA が NG の場合、Root Planner に戻して修正ループ（Single-task または 3〜5 の修正タスク）

## コンセプト

- 小スコープは Single-task を優先して高速に流す
- 並列化する場合のみ 3〜5 に分割してスループットを上げる
- タスク仕様（TaskSpec）に `AssignedWorker` と `SkillCards`（最大 2）を必須化して迷子を防ぐ
- QA は「合否」「Blockers（最大 3）」「次アクション」を固定フォーマットで返す
- 要件定義/設計/参考情報のドキュメント場所（ファイルパス/URL）は、ユーザーが Root Planner に提示する前提。未提示なら Root Planner が質問して確認する

## 含まれるコンポーネント

- `agents/`: Root Planner / SubPlanner / Integrator / QA / 領域 Worker
- `rules/`: 運用プロトコル、QA ゲート、安全なシェル実行のガードレール
- `commands/`: 計画、ハンドオフ、統合、QA、NG→修正計画の定型プロンプト
- `hooks/`: 最小の安全柵（任意）

## 使い方（最短）

1. `commands/ma-plan.md` を使って TaskSpec を作成する
2. TaskSpec の `AssignedWorker` と `SkillCards`（最大 2）を埋める
3. 並列タスク（3〜5）の場合は `commands/ma-parallel-agents.md` に従って、並列エージェントで Worker を起動して Apply で取り込む
4. 各領域 Worker は専用 worktree 上で実装し、`commands/ma-handoff.md` のフォーマットでハンドオフを提出する
5. `commands/ma-integrate.md` に沿って統合し、`commands/ma-qa.md` で QA を実行する
6. QA が NG なら `commands/ma-qa-fail-to-fixplan.md` で修正計画を作り、ループする
7. 手動 `git worktree` を使った場合のみ `commands/ma-worktree-cleanup.md` で片付ける

## サブエージェント運用の注意

- サブエージェントは空のコンテキストから開始します。Root Planner は並列タスクの Worker プロンプトに、必要な情報（参照ドキュメントの場所、受け入れ条件、最小チェック、スコープ）をすべて含めてください。
- 並列エージェントは専用 worktree で動作します。通常は Cursor が worktree を自動で作成・管理します。
- worktree 上では LSP が利用できない場合があります。診断は「テスト/ビルド/最小チェックの実行結果」を優先してください。

## プロンプト例

以下は、プラグインを利用する際のプロンプト例です。

### Root Planner にオーケストレーションを依頼する（2段階）

```text
あなたは `root-planner` です。
次の要件を満たすために、次の2段階で進めてください。

1. まず、ユーザーが読みやすい文章（Markdownの箇条書き）で「実装計画」を作成してください。ここでは YAML は出さないでください。
2. ユーザーが計画を承認したら、TaskSpec YAML を作成し、並列エージェントで Worker に委譲して作業を開始してください。最終的に QA に委譲し、問題が無くなるまで修正ループを回す段取りも提示してください。

- 目的: 決済状況の確認画面を追加したい
- 要件/設計/参考情報: `docs/payments/status-screen.md`（なければ、参照すべきドキュメント場所を質問して確認してから進めて）
- 制約: 既存UIのパターンを踏襲。SkillCardsは最大2。受け入れ条件は最大3。
- やらないこと: 決済ロジック自体の変更はしない

計画フェーズの出力要件:
- 実装計画（文章）: Single-task か Parallel（3〜5）かの判断理由を含める
- Parallelの場合: 分割方針（領域Workerへの割当）とリスク（競合、依存）を含める
- 検証方針: `minimal_checks` の考え方を含める（コマンドは未確定なら `<PROJECT_DEFINED>`）
- 最後に「この計画で進めてよいか」を質問して承認を取る

承認後フェーズの出力要件:
- TaskSpec YAML（Mode: single または Mode: parallel）
- Mode: parallel の場合は、各タスクを担当する Worker エージェント名と、そのまま実行できる作業指示プロンプトを 3〜5 個（並列エージェントで起動するため）
- Apply→統合→QA の手順（どの順で何を実行するか）
- QA Fail の場合に、修正タスク（Single-taskまたは3〜5）と Worker への修正指示プロンプトを提示する手順

注意:
- Worker は空のコンテキストから開始します。作業指示プロンプトには必要情報（参照ドキュメント、受け入れ条件、最小チェック、スコープ）をすべて含めてください。
```

### 並列エージェントを実行する（Root Plannerが起動し、ユーザーはApplyする）

```text
Root Planner が Worker を 3〜5 並列で起動します。
ユーザーは各結果カードを確認し、必要なものから順に Apply でプライマリ作業ツリーに取り込みます。
```

### Worker に実装させる（Root Planner が起動時に渡すプロンプトの例）

```text
あなたは `worker-frontend` です。
次の TaskSpec に従って実装してください。

<ここにTaskSpecを貼る>

並列タスクの場合は専用 worktree 上で作業し、
ハンドオフは `commands/ma-handoff.md` のテンプレで提出してください。
```

### Integrator に統合を依頼する

```text
あなたは `integrator` です。
次の複数ハンドオフを統合し、QAに渡せる状態にしてください。

- TaskSpec:
  <ここにTaskSpecを貼る>
- Handoffs:
  <ここにハンドオフを貼る>

IntegrationReport を返してください。
```

### QA に合否判定を依頼する

```text
あなたは `qa` です。
次の統合状態に対して QA ゲートを実行し、合否と次アクションを返してください。

- TaskSpec:
  <ここにTaskSpecを貼る>
- IntegrationReport:
  <ここにIntegrationReportを貼る>

制約:
- blockers は最大3
- next_fix_plan は Single-task または 3〜5

QAResult 形式で出力してください。
```

### QA Fail を修正計画に落とす

```text
あなたは `root-planner` です。
次の QAResult（Fail）を、修正タスク（Single-taskまたは3〜5）に落としてください。
各タスクに assigned_worker と skill_cards（最大2）を必ず付与してください。

前提: 参照すべき要件/設計/参考情報の場所が不明な場合は、修正計画を作る前に質問して確認してください。

<ここにQAResultを貼る>

出力は TaskSpec YAML（修正計画）で返してください。
```

## 注意

- 本プラグインはツール連携（MCP）に依存しません。プロジェクト固有のテストコマンドは、SkillCard の `minimal_checks` に `<PROJECT_DEFINED>` として記載して運用してください。
- `hooks/` は安全柵として最小限の設定です。プロジェクト運用に合わせて調整してください。
