# GitLabで実現するDevSecOpsとAI連携

## 概要

GitLabを使用したDevSecOps、及びAIレビューの開発プロセス組込み実装とデモ。

本リポジトリにコミットされたマークダウンファイルを、CI/CDパイプラインを通じてLint（構文チェック）、AIレビューを行い、最終的にWebサイトへ自動デプロイする。

## 目的

本リポジトリの実装と実行結果を通じて、以下3点を説明する。

### DevSecOps

迅速、軽量な開発とサイクル全体のセキュリティスキャンを実現する。

### Docs as Code

ドキュメントをコードと同様に扱うアプローチ。このアプローチでは、ドキュメントはバージョン管理され、レビュープロセスが適用される。これにより、ドキュメントの品質が向上し、チーム間での情報共有が容易となる。CI/CDパイプラインを活用することで、ドキュメントの自動ビルド、テスト、デプロイを実現する。

Docs as Codeのアプローチによって生成したドキュメントをWebページとして公開し、DevSecOpsの要点を説明する。

### 開発プロセスへのAIレビュー組込み

リポジトリとOpenAIをCI/CDパイプラインを通じて連携し、開発プロセスの自動化と効率化を促進する。AIを活用することで、コードレビュー、ドキュメントのチェック、セキュリティ評価などを自動化し、より速く、より正確に行うことができる。本実装ではgitからのデータ抽出とOpenAI連携部分をコンテナ化し、CI/CDテンプレートから呼びだすことで、各リポジトリへの個別実装なくAIレビューを実現する。

## アーキテクチャ

### Docs

```mermaid
graph LR
subgraph OpenAI
    API
end
subgraph GitLab
    subgraph リポジトリ
        マークダウン
    end
    subgraph CICDパイプライン
        subgraph テスト
            Markdown-Link-Check
            Markdown-Lint
            Text-Lint
        end
        AIレビュー
        Gitbook
        Marp
        HTML
    end
    subgraph コンテナレジストリ
        OpenAI-Review
    end
    subgraph GitLab Pages
        Webサイト
    end
    マージリクエスト
    マークダウン--リンクチェック-->Markdown-Link-Check
    マークダウン--構文チェック-->Markdown-Lint
    マークダウン--日本語チェック-->Text-Lint
    マークダウン--レビュー-->AIレビュー
    AIレビュー--変更内容-->OpenAI-Review
    OpenAI-Review--ドキュメントレビュー依頼-->API
    API--ドキュメントレビュー結果-->OpenAI-Review
    OpenAI-Review--レポート-->マージリクエスト
    マークダウン--ビルド-->Gitbook
    マークダウン--ビルド-->Marp
    Gitbook--変換-->HTML
    Marp--変換-->HTML
    HTML--デプロイ-->Webサイト
end
```

- [リポジトリ](https://gitlab.com/taku-miyanaga/docs)
- [パイプライン](https://gitlab.com/taku-miyanaga/docs/-/pipelines/1061807587)
- [マージリクエスト](https://gitlab.com/taku-miyanaga/docs/-/merge_requests/1)

### OpenAI-Review

```mermaid
graph LR
subgraph OpenAI
    API
end
subgraph GitLab
    subgraph リポジトリ
        コード
    end
    subgraph CICDパイプライン
        Dockerイメージ
        subgraph DevSecOps
            Code_Quality
            Container_Scan
            Secret_Detection
            SAST
            Unit_Test
        end
        AIレビュー
    end
    subgraph コンテナレジストリ
        OpenAI-Review
    end
    マージリクエスト
    コード--ビルド-->Dockerイメージ
    Dockerイメージ--デプロイ-->OpenAI-Review
    コード--コード品質チェック-->Code_Quality
    コード--脆弱性チェック-->Container_Scan
    コード--機密情報チェック-->Secret_Detection
    コード--静的解析-->SAST
    コード--テスト-->Unit_Test
    Code_Quality--レポート-->マージリクエスト
    Container_Scan--レポート-->マージリクエスト
    Secret_Detection--レポート-->マージリクエスト
    SAST--レポート-->マージリクエスト
    Unit_Test--レポート-->マージリクエスト
    コード--レビュー-->AIレビュー
    AIレビュー--変更内容-->Dockerイメージ
    Dockerイメージ-- コードレビュー依頼-->API
    API--コードレビュー結果-->Dockerイメージ
    Dockerイメージ--レポート-->マージリクエスト
end
```

- [リポジトリ](https://gitlab.com/taku-miyanaga/openai-review)
- [パイプライン](https://gitlab.com/taku-miyanaga/openai-review/-/pipelines/1061803197)
- [マージリクエスト](https://gitlab.com/taku-miyanaga/openai-review/-/merge_requests/1)
