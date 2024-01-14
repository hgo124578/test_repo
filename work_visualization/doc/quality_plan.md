以下の品質計画について、改善箇所をコメントしてください。


# 品質計画

## 目的
このドキュメントの目的は、チームの品質保証の方針を明確にし、定義することです。

## 品質基準,品質目標,計測方法
- Job稼働率 XX%以上: Availability Dashboardでの稼働率。Sprint毎に集計
- Job failにおけるinternal エラー率：XX%以下
- モニタリング時間: XXh/sprint以下
- maintenance時間 :XXh/sprint以下


## 品質レビューを受けるプロジェクトの成果物とプロセス
### 成果物
- PS pipeline
- DP pipeline
- PME
- PJPC
- PTEC
- staging apps
- template

### プロセス 
1. 各成果物のリリース（＝ユーザーの利用開始）前に、レビューにてリリース基準を満たしていることを確認し、満たしていない場合はリリース不可。（ただし、作業の都合による一時的な仮リリース等はOK）
2. リリース後、定期的に前述の品質を計測する。品質が期待を下回る場合は原因を特定し、リリース基準品質にフィードバックする。
3. リリース後、定期的にテストを実行し、外部libraryやインフラのupdateをキャッチアップする。変化があった場合、成果物、テストにフィードバックする。


## リリース品質基準
以下の観点から、各成果物が品質目標を満たすことが見込まれることを確認する。
- 機能性
機能テストで確認
- 効率性
パフォーマンステストで確認
- 保守性
（可能なものには）静的解析ツールによって確認


## テスト方針
以下を原則として、成果物毎にテストを定義する。

### 目的
- リリース後の定期的なテストで、外部libraryやインフラのupdateをキャッチアップする。
- リリース品質基準として
- 開発スピードをあげること

### 前提
以下について定義済みであること。
- job及びそれを構成する各moduleの仕様
- targetとする環境

### テスト対象
前述の成果物

### テストスコープ
1. 機能テスト
各成果物の機能が仕様を満足していることのテスト。
2. performance テスト
各成果物の機能に対しての速度, 安定性のテスト。

### テストタイミング
1. 成果物リリース時のテスト
成果物が正しくUpdateされており、また、想定外の不具合が混入されていないことを確認する為のテスト。
2. 成果物開発中のテスト
開発中の成果物に想定外の不具合が混入されていないことを確認する為のテスト。
3. 定期実行のテスト
外部libraryやインフラのupdate等、利用しているmoduleのupdateをチーム内でキャッチできないケースに対応するため、定期的にテストを繰り返す。

### テスト規模
1. smallテスト
module内のテスト。Job及びローカル環境で使われることを想定。
2. bigテスト
複数のmodule間の連携テスト。Jobから使われることを想定。








## PerfS pipeline
### 機能テスト
pipeline内の処理I/Oが仕様と整合していることの確認
LibraryのIntegrateの適切であることの確認。（I/Oが整合していること）

### 性能テスト
pipeline全体で、適切な実行時間であることの確認。
pipeline全体を繰り返し実行しても、結果が安定していることの確認。

### テスト環境
PS pipelineのupdateは最終的に、templateに含めて、ロールアウトすることで各appsに適用される。
このupdate内容はstaging appsのPS pipelineで検証することが前提であるため、staging appsのPS pipelineをtest targetとする。

### テスト実装
smallテスト、bigテストのいずれも、PS pipeline内から呼び出すものとする。
テストコード及びmock処理をPS pipelineに直接実装してもいい。

### big testのscope
以下のmodule間の疎通
- JPC:defined in PS pipeline
- NJPC:defined in PS pipeline
- PJPC:defined in PS pipeline
- ELK:latest
- UI automation:defined in staging apps
- PTEC:defined in staging apps

## テスト実装アプローチ

