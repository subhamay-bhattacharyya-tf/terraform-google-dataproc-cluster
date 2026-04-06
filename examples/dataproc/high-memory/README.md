# High-Memory Dataproc Cluster

Dataproc cluster with `n1-highmem-8` machine types on both master and worker nodes, suited for memory-intensive Spark workloads such as large in-memory joins and aggregations.

## Usage

```bash
terraform init -backend=false
terraform validate
```
