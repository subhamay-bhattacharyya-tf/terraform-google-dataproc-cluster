# GCP — Dataproc Cluster Variables

See the full variable schema and module call example in [SKILL.md](SKILL.md#gcp).

## `dataproc_cluster_config` field reference

| Field | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Lowercase alphanumeric + hyphens, max 30 chars |
| `image_version` | `string` | No | `"2.1-debian11"` | Dataproc image version string |
| `master_machine_type` | `string` | No | `"n1-standard-4"` | GCE machine type |
| `master_num_instances` | `number` | No | `1` | Must be `1` or `3` (HA) |
| `master_disk_size_gb` | `number` | No | `100` | Must be >= 10 |
| `worker_machine_type` | `string` | No | `"n1-standard-4"` | GCE machine type |
| `worker_num_instances` | `number` | No | `2` | Must be >= 2 |
| `worker_disk_size_gb` | `number` | No | `100` | Must be >= 10 |
| `preemptible_worker_num_instances` | `number` | No | `0` | 0 = disabled |
| `network` | `string` | No | `null` | VPC network name or self-link |
| `subnetwork` | `string` | No | `null` | Subnet name or self-link |
| `service_account_email` | `string` | No | `null` | SA for cluster nodes |
| `enable_http_port_access` | `bool` | No | `true` | Yarn/Spark web UIs |
| `idle_delete_ttl` | `string` | No | `null` | e.g. `"3600s"` |
| `optional_components` | `list(string)` | No | `[]` | e.g. `["JUPYTER"]` |
| `labels` | `map(string)` | No | `{}` | Lowercase keys/values |
