---
marp: true
theme: default
size: 16:9
paginate: true
style: div.mermaid { all: unset; }
---
<script src="https://unpkg.com/mermaid@10/dist/mermaid.min.js"></script>

<!-- omit in toc -->
# GitLab開発ガイドライン

---
<!-- omit in toc -->
# 概要

本ガイドラインでは、GitLabでの開発を最初から全6ステップで説明する。詳細手順は各リンク先に確認のこと。

---
<!-- omit in toc -->
# 6つのステップ

[Step1. リポジトリ作成と初期設定](#4)
[Step2. ブランチフロー策定](#7)
[Step3. タスク管理](#10)
[Step4. 開発](#13)
[Step5. CICDパイプライン構築](#16)
[Step6. 脆弱性管理](#19)

---

# Step1. リポジトリ作成と初期設定

---

# Step1. 概要

最初にGitLabにリポジトリを作成し、初期設定を実施する。

<div class="mermaid">
graph LR
  開発者
  subgraph GitLab
      リポジトリ
      ユーザ設定
  end
  開発者 -- 新規作成 --> リポジトリ
  開発者 -- 初期設定 --> ユーザ設定
</div>

---

# Step1. 詳細手順

## リポジトリ作成

新規  
[GitLab日本語マニュアル プロジェクトの作成](https://gitlab-docs.creationline.com/ee/user/project/)

既存リポジトリを移行  
[GitLabへのリポジトリ移行手順](../../md/GitLabへのリポジトリ移行手順/GitLabへのリポジトリ移行手順.html)

## 初期設定

[EntraIDでのGitLabユーザ追加手順](../../md/EntraIDでのGitLabユーザ追加手順/EntraIDでのGitLabユーザ追加手順.html)

[GitLab初回SSOログイン手順](../../md/GitLab初回SSOログイン手順/GitLab初回SSOログイン手順.html)

[GitLabユーザ初期設定手順](../../md/GitLabユーザ初期設定手順/GitLabユーザ初期設定手順.html)

---

# Step2. ブランチフロー策定

---

# Step2. 概要

プロジェクトのブランチフローを決め、チーム内でルールを共有する。

<div class="mermaid">
graph LR
  開発者
  subgraph GitLab
    リポジトリ
    ブランチ
  end
  開発者 -- ブランチルール設定 --> リポジトリ
  開発者 -- 作成 --> ブランチ
  開発者 -- ルール共有 --> チーム
</div>

---

# Step3. タスク管理

---

# Step3. 概要

リーダーはスケジュールをマイルストーン、エピックで作成し、タスクをイシュー化してメンバーに割当てる。

<div class="mermaid">
graph LR
    リーダー
  subgraph GitLab
    subgraph ロードマップ
      マイルストーン
      エピック
    end
    subgraph イシューボード
      イシュー
    end
  end
  リーダー -- 大日程 --> マイルストーン
  リーダー -- スケジュール/中タスク --> エピック
  リーダー -- タスク --> イシュー
  メンバー -- 参照 --> イシュー
</div>

---

# Step4. 開発

---

# Step4. 概要

メンバーは開発スタート時、担当イシューからブランチ・マージリクエストを作成し、実装後にレビュー依頼を送付する。

<div class="mermaid">
graph LR
  リーダー
  subgraph GitLab
      担当イシュー
      開発ブランチ
      メインブランチ
      マージリクエスト
  end
  メンバー -- 参照 --> 担当イシュー
  メンバー -- 作成/コミット --> 開発ブランチ
  メンバー -- 作成/レビュー依頼 --> マージリクエスト
  マージリクエスト -- レビュー依頼 --> リーダー
  リーダー -- レビュー/承認 --> マージリクエスト
  開発ブランチ --- マージリクエスト
  マージリクエスト -- マージ --> メインブランチ
</div>

---

# Step5. CICDパイプライン構築

---

# Step5. 概要

CICDパイプラインを設定(.gitlab-ci.yml)し、コミット時にジョブを自動実行する。

<div class="mermaid">
graph LR
  開発者
  subgraph GitLab
      .gitlab-ci.yml
      リポジトリ
    subgraph CICDパイプライン
      ビルド
      セキュリティチェック
      自動テスト
      自動デプロイ
    end
  end
  開発者 -- 設定 --> .gitlab-ci.yml
  開発者 -- コミット --> リポジトリ
  リポジトリ -- 参照 --> .gitlab-ci.yml
  リポジトリ -- ジョブ実行 --> ビルド
  リポジトリ -- ジョブ実行 --> セキュリティチェック
  リポジトリ -- ジョブ実行 --> 自動テスト
  リポジトリ -- ジョブ実行 --> 自動デプロイ
</div>

---

# Step6. 脆弱性管理

---

# Step6. 概要

CICDパイプラインのセキュリティチェックで検知した脆弱性をトリアージする。

<div class="mermaid">
graph LR
subgraph GitLab
  リポジトリ
  VulnerabilityReport_A(脆弱性レポート)
  subgraph CICDパイプライン
    セキュリティチェック
  end
end
subgraph  NVD
    脆弱性データベース
end
開発者 -- コミット --> リポジトリ
開発者 -- トリアージ --> VulnerabilityReport_A
リポジトリ -- ジョブ実行 --> セキュリティチェック
セキュリティチェック -- 検知 --> VulnerabilityReport_A
セキュリティチェック -- 参照 --> 脆弱性データベース
</div>

---

# まとめ

以上が、GitLabを用いた開発の一連の流れとなる。

開発サイクル完成後は、Step3.タスク管理 ～ Step6.脆弱性管理をなるべく早く細かく循環させることでGitLabを用いたDevSecOpsが実現する。

<div class="mermaid">
graph TB
subgraph GitLab
  subgraph タスク管理
    計画
  end
  subgraph 開発
    コーディング
  end
  subgraph CICD
    ビルド
    テスト
    脆弱性管理
    デプロイ
  end
  デプロイ --> 計画
  計画 --> コーディング
  コーディング --> ビルド
  ビルド --> テスト
  テスト --> 脆弱性管理
  脆弱性管理 --> デプロイ
end
</div>

※参考 [チームのDevOpsレベル評価と改善](../../md/チームのDevOpsレベル評価と改善/チームのDevOpsレベル評価と改善.html)

---

# 以上
