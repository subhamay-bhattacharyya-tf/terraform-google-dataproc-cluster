# GCP — Dataproc Cluster

See the full annotated example and quick-reference tables in [SKILL.md](SKILL.md#gcp).

## Key resource blocks for `google_dataproc_cluster`

| Block | Conditional? | Notes |
|---|---|---|
| `cluster_config.software_config` | No | Always set `image_version` and `optional_components` |
| `cluster_config.master_config` | No | Set `num_instances = 3` for HA |
| `cluster_config.worker_config` | No | Minimum `num_instances = 2` |
| `cluster_config.preemptible_worker_config` | Yes — `count > 0` | Use `dynamic` block |
| `cluster_config.gce_cluster_config` | Yes — network/SA set | Use `dynamic` block |
| `cluster_config.endpoint_config` | Yes — `enable_http_port_access` | Use `dynamic` block |
| `cluster_config.lifecycle_config` | Yes — `idle_delete_ttl != null` | Use `dynamic` block |

## Provider registry

- [`google_dataproc_cluster`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataproc_cluster)
