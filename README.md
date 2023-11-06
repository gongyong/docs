# GitLabで実現するDevSecOpsとAI連携

## 概要

本リポジトリにコミットされたマークダウンファイルは、CI/CDパイプラインでLint、AIレビューを経てWebサイトに自動デプロイされる。

## 目的

- GitLabを用いたDevSecOpsの実装デモ
- GitLabで実現するDevSecOpsの説明
- Documentation as Codeの実装デモ
- 開発プロセスへのAI自動レビュー組込みデモ

## 全体処理イメージ

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
        Lint
        AIレビュー
        Gitbook
        HTML
    end
    subgraph コンテナレジストリ
        OpenAI-Review
    end
    subgraph GitLab Pages
        Webサイト
    end
    マージリクエスト
    マークダウン--チェック-->Lint
    マークダウン--レビュー-->AIレビュー
    AIレビュー--変更内容-->OpenAI-Review
    OpenAI-Review--ドキュメントレビュー依頼-->API
    API--ドキュメントレビュー結果-->OpenAI-Review
    OpenAI-Review--レポート-->マージリクエスト
    マークダウン--ビルド-->Gitbook
    Gitbook--変換-->HTML
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
    Dockerイメージ-- ソースコードレビュー依頼-->API
    API--ソースコードレビュー結果-->Dockerイメージ
    Dockerイメージ--レポート-->マージリクエスト
end
```

- [リポジトリ](https://gitlab.com/taku-miyanaga/openai-review)
- [パイプライン](https://gitlab.com/taku-miyanaga/openai-review/-/pipelines/1057805396)
- [マージリクエスト](https://gitlab.com/taku-miyanaga/openai-review/-/merge_requests/1)
