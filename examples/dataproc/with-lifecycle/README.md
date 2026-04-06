# Dataproc Cluster with Lifecycle (Auto-Delete)

Dataproc cluster configured to auto-delete after 1 hour of idle time, preventing runaway costs from forgotten development clusters.

## Usage

```bash
terraform init -backend=false
terraform validate
```
