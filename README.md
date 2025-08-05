# TG DevCamp Discord Terraform

このプロジェクトは、TerraformのDiscord Providerを使用してDiscordサーバーのリソースを管理するためのツールです。年度ごとにチャンネルやロールを自動的に作成・管理できます。

## 概要

- **年度別チャンネル管理**: 年度ごとにカテゴリやチャンネルを整理して管理
- **チーム管理**: チームごとにpublic/privateチャンネルとボイスチャンネルを自動作成
- **権限管理**: チームメンバーのロール割り当てとチャンネル権限の自動設定
- **GitLab Terraform State対応**: リモート状態管理でチーム開発をサポート
- **Docker対応**: Apple SiliconでもDocker経由で実行可能

## プロジェクト構造

```
.
├── docker-compose.yml          # Terraformコンテナの設定
├── docker/
│   └── terraform/
│       ├── Dockerfile          # カスタムTerraformイメージ
│       └── .bashrc             # direnv自動設定
├── .env.sample                 # 環境変数のサンプル
├── LICENSE
└── services/
    └── discord/
        ├── environments/
        │   └── pro/
        │       ├── provider.tf         # Discord Provider設定
        │       ├── common.tf           # 共通設定
        │       ├── server/             # サーバー管理
        │       │   ├── main.tf
        │       │   ├── backend.tf
        │       │   ├── variables.tf
        │       │   ├── outputs.tf
        │       │   └── .envrc         # TF_STATE_NAME設定
        │       └── channels_20xx/      # 20xx年度チャンネル設定
        │           ├── main.tf
        │           ├── backend.tf
        │           ├── variables.tf
        │           ├── outputs.tf
        │           └── .envrc         # TF_STATE_NAME設定
        └── modules/
            ├── provider.tf
            ├── server/                 # サーバーモジュール
            ├── whole_channels/         # 全体チャンネルモジュール
            └── teams_channels/         # チームチャンネルモジュール
```

## 機能

### 全体チャンネル
- **連絡チャンネル**: アナウンス用のニュースチャンネル
- **質問フォーラム**: Q&A用のフォーラムチャンネル
- **自己紹介チャンネル**: 参加者の自己紹介用テキストチャンネル
- **雑談チャンネル**: 自由な会話用テキストチャンネル
- **談話ルーム**: 複数のボイスチャンネル

### チームチャンネル
各チームには以下のチャンネルが自動作成されます：
- **publicチャンネル**: 全員が閲覧可能なテキストチャンネル
- **privateチャンネル**: チームメンバーのみアクセス可能なテキストチャンネル
- **talkチャンネル**: チームメンバー専用のボイスチャンネル

## 実行方法

### 1. Discord
1. サーバーを新規作成する  
2. 作成したサーバーのIDを取得する  
   - [ユーザー/サーバー/メッセージIDはどこで見つけられる？｜Discord Support](https://support.discord.com/hc/ja/articles/206346498-%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC-%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8ID%E3%81%AF%E3%81%A9%E3%81%93%E3%81%A7%E8%A6%8B%E3%81%A4%E3%81%91%E3%82%89%E3%82%8C%E3%82%8B) を参考にサーバーIDを取得  
   - 取得したサーバーIDを`.env`ファイルに設定  

### 2. Discord Developer Portal
1. アプリケーションを作成する（アプリケーション名はサーバー内のユーザーに表示される）  
2. アプリケーションの設定からBotを作成し、Bot Tokenを取得  
   - 取得したBot Tokenを`.env`ファイルに設定  
3. Privileged Gateway Intentsを有効化  
4. OAuth2 URL Generatorでサーバーに追加するためのURLを生成  
   - SCOPES: bot  
   - BOT PERMISSIONS: Administrator  
5. 生成したURLにアクセスし、アプリケーションをサーバーに追加  

### 3. （BackendをGitLab Terraform Stateにする場合）GitLab
1. GitLab Personal Access Tokenを取得  
   - 取得したPersonal Access Tokenを`.env`ファイルに設定  
2. GitLab Terraform StateのURLを取得  
   - 取得したURLを`.env`ファイルに設定  
   - URL形式は `https://[gitlab_domain]/api/v4/projects/[project_id]/terraform/state`  
3. ディレクトリに`.envrc`を作成し、以下の内容を設定

   ```bash
   export TF_STATE_NAME=[Terraform Stateの名前]
   ```

### 4. Terraform

1. Docker上でTerraformコンテナを起動し、Terraformを実行  
   （使用しているTerraform Providerがx86_64のみ対応のため、Apple SiliconではDockerを利用）  
   カスタムDockerイメージには`bash`と`direnv`が含まれています。

    ```bash
    docker compose run --rm terraform
    ```

2. Terraform Initを実行  
   GitLab Terraform Stateを利用する場合は、GitLabの画面表示に従う

3. 設定を適用

    ```bash
    # サーバー設定を先に適用
    cd services/discord/environments/pro/server
    direnv allow
    terraform plan
    terraform apply

    # 既存チャンネルを利用する場合は`terraform import`を使用

    # その後チャンネル設定を適用
    cd ../channels
    direnv allow
    terraform plan
    terraform apply
    terraform apply  # 1回目のapplyではチャンネルのpositionが正しく反映されないため、2回目のapplyを実行
    ```

## 環境変数

`.env.sample`を`.env`にコピーして、以下の環境変数を設定してください：

```bash
# Discord設定
TF_VAR_discord_token=           # Discord Bot Token
TF_VAR_discord_server_id=       # Discord Server ID

# GitLab設定（GitLab Terraform Stateを使用する場合）
TF_VAR_gitlab_remote_state_address=    # GitLab Terraform State URL
TF_VAR_gitlab_username=                # GitLab Username
TF_VAR_gitlab_access_token=            # GitLab Personal Access Token
GITLAB_ACCESS_TOKEN=                   # GitLab Personal Access Token（Terraform用）
```

## カスタマイズ

### チャンネル設定の変更

`services/discord/environments/pro/channels_20xx/variables.tf`を編集することで、チャンネル設定をカスタマイズできます：

> [!NOTE]
> 年度を追加する場合は、`services/discord/environments/pro/channels_20xx/`を複製し、`variables.tf`を編集して下さい。

```hcl
# 年度設定
variable "year" {
  default = "20xx"  # 管理する年度
}

# 全体チャンネル設定
variable "whole_channels" {
  default = {
    talk_room_names = [
      "談話ルームA",
      "談話ルームB"
    ]
  }
}

# チーム設定
variable "teams" {
  type = map(list(string))
  
  default = {
    "チームA" = ["ユーザーID1", "ユーザーID2"]
    "チームB" = ["ユーザーID3", "ユーザーID4"]
  }
}
```

> [!CAUTION]
> ユーザーIDはユーザーが定義する英数字の文字列ではなく、Discord側で定義される17桁または18桁の数字です。
> 
> [ユーザー/サーバー/メッセージIDはどこで見つけられる？｜Discord Support](https://support.discord.com/hc/ja/articles/206346498-%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC-%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8ID%E3%81%AF%E3%81%A9%E3%81%93%E3%81%A7%E8%A6%8B%E3%81%A4%E3%81%91%E3%82%89%E3%82%8C%E3%82%8B) を参考にユーザーIDを取得してください。

> [!WARNING]
> `terraform destroy`を実行すると、全てのリソースを削除することができますが、復元はできませんのでご注意ください。

## トラブルシューティング

### Apple SiliconでProviderエラーが発生する場合

このプロジェクトではDocker経由での実行を推奨しています。`docker-compose.yml`で`platform: linux/amd64`を指定しているため、Apple Siliconでも正常に動作します。

### Terraform Importについて

既存のDiscordリソースを管理下に置く場合は、`terraform import`コマンドを使用してください：

```bash
# 連絡チャンネルのインポート例
terraform import module.whole_channels.discord_news_channel.announcement "<channel id>"
```
