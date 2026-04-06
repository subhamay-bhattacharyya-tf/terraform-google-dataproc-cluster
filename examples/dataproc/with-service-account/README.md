# Dataproc Cluster with Custom Service Account

Dataproc cluster whose nodes run as a specific service account, enabling fine-grained IAM control over what GCP resources the cluster can access (e.g. GCS buckets, BigQuery datasets).

## Usage

```bash
terraform init -backend=false
terraform validate
```
