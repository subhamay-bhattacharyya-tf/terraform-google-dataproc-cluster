# Dataproc Cluster with Preemptible Workers

Dataproc cluster with 4 preemptible (spot) secondary workers to reduce compute costs. Suitable for fault-tolerant batch workloads that can handle node preemption.

## Usage

```bash
terraform init -backend=false
terraform validate
```
