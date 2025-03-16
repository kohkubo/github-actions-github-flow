# Google Cloud API管理

このTerraformコードはGoogle CloudプロジェクトのAPIを管理するためのものです。

## 使い方

1. `terraform.tfvars.example`を`terraform.tfvars`にコピーして必要な値を設定します：

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. `terraform.tfvars`ファイルを編集して、プロジェクトIDと有効化したいAPIを設定します。

3. Terraformを初期化します：

```bash
terraform init
```

4. 実行計画を確認します：

```bash
terraform plan
```

5. 変更を適用します：

```bash
terraform apply
```

## 変数

- `project_id`: Google Cloudプロジェクトの識別子
- `region`: リソースをデプロイするリージョン（デフォルト: `asia-northeast1`）
- `apis`: 有効化するAPIのリスト

## 注意点

- APIを無効化したい場合は、`apis`リストから削除し、`terraform apply`を実行します。
- `disable_on_destroy`は`false`に設定されているため、Terraformリソースを削除してもAPIは無効化されません。

## GitHub Actions による自動デプロイ

このリポジトリにはGitHub Actionsを使用したTerraformの自動デプロイ設定が含まれています。

### 前提条件

1. GitHubリポジトリの設定で以下のシークレットとリポジトリ変数を設定:

   - シークレット:
     - `GCP_SA_KEY`: Google Cloudサービスアカウントのキー（JSON形式）

   - リポジトリ変数:
     - `GCP_PROJECT_ID`: 対象のGoogle CloudプロジェクトID

### ワークフローの動作

- **プルリクエスト時**: Terraform planが実行され、結果がPRのコメントとして表示されます。
- **mainブランチへのマージ時**: Terraform変更が自動的に適用されます。
- **手動実行**: GitHub Actionsのワークフローから手動でデプロイを実行できます。

### サービスアカウントの権限

サービスアカウントには以下の権限が必要です:

- `roles/serviceusage.serviceUsageAdmin`: APIの有効化/無効化
- `roles/resourcemanager.projectIamAdmin`: プロジェクトへのアクセス

サービスアカウントキーの取得方法:

```bash
# サービスアカウントの作成
gcloud iam service-accounts create terraform-deployer --display-name="Terraform Deployer"

# 必要な権限を付与
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:terraform-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/serviceusage.serviceUsageAdmin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:terraform-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"

# サービスアカウントキーの生成（JSONファイル）
gcloud iam service-accounts keys create key.json \
  --iam-account=terraform-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

test
