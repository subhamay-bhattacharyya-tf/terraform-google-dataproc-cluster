# Terraform Template Specification

Generate these files in the `/` directory:

**main.tf:** _(delegate to `tf-mod-main` skill)_

- Google Dataproc Cluster using the `google_dataproc_cluster` resource
- Follow the GCP provider reference and core authoring patterns from the `tf-mod-main` skill

**locals.tf:**

A locals block must be created from the input variable. The cluster name must follow this format:

```text
<project_code>-<base_name>-<region>-<environment>
```

**variables.tf:** _(delegate to `tf-mod-vars` skill)_

Use the `tf-mod-vars` skill to author this file. Apply the GCP provider reference and validation patterns. The variable schema is:

| Variable | Type | Required | Notes |
| --- | --- | --- | --- |
| `environment` | `string` | Yes | One of: `devl`, `test`, `prod` |
| `project_code` | `string` | Yes | Short identifier for naming standardization |
| `region` | `string` | No | Default: `us-central1` |
| `dataproc_cluster_config` | `object` | Yes | See attribute table below |

`dataproc_cluster_config` attributes:

| Attribute | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Alphanumeric or dashes, max length ≤ 30 |
| `image_version` | `string` | No | `"2.1-debian11"` | Dataproc image version string |
| `master_machine_type` | `string` | No | `"n1-standard-4"` | GCE machine type for master node |
| `master_num_instances` | `number` | No | `1` | Must be 1 (standard) or 3 (HA) |
| `master_disk_size_gb` | `number` | No | `100` | Must be >= 10 |
| `worker_machine_type` | `string` | No | `"n1-standard-4"` | GCE machine type for worker nodes |
| `worker_num_instances` | `number` | No | `2` | Must be >= 2 for standard clusters |
| `worker_disk_size_gb` | `number` | No | `100` | Must be >= 10 |
| `preemptible_worker_num_instances` | `number` | No | `0` | Number of preemptible/spot workers |
| `network` | `string` | No | `null` | VPC network name or self-link |
| `subnetwork` | `string` | No | `null` | Subnet name or self-link |
| `service_account_email` | `string` | No | `null` | SA email for cluster nodes |
| `enable_http_port_access` | `bool` | No | `true` | Expose Yarn/Spark web UIs |
| `idle_delete_ttl` | `string` | No | `null` | Auto-delete when idle, e.g. `"3600s"` |
| `optional_components` | `list(string)` | No | `[]` | e.g. `["JUPYTER", "ZEPPELIN"]` |
| `labels` | `map(string)` | No | `{}` | GCP labels (lowercase keys/values) |

**outputs.tf:**

- Outputs for all standard Google Dataproc Cluster attributes:
  - `cluster_id`
  - `cluster_name`
  - `cluster_project`
  - `cluster_region`
  - `master_instance_names`
  - `worker_instance_names`
  - `http_ports`

**versions.tf:**

- Versions.tf should be in the following format

```hcl

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.23.0"
    }
  }
}

provider "google" {
  region = var.region
}
```

**examples/:** _(delegate to `tf-mod-examples` skill)_

Use the `tf-mod-examples` skill to scaffold the full example matrix. Each example must be a self-contained, independently validatable Terraform configuration under `examples/<name>/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

**test/:**

- `test/dataproc_cluster_basic_test.go`: Terratest that creates a real Dataproc cluster, asserts key outputs (name, uuid, master/worker instance names), and destroys it.

**package.json:**

- `github/workflows/ci.yaml`: This is the CI Pipeline. Add all the tests in the terratest job.

Ensure the name is always the repository name.

**package-lock.json:**

Ensure the name is always the repository name.

**CONTRIBUTING.md:**

Ensure in the CONTRIBUTING.md, Reporting Issues must always link to the current repository.

**README.md:** _(delegate to `tf-mod-readme` skill)_

Use the `tf-mod-readme` skill to generate this file. The skill will:

- Auto-resolve the repository name from the current git root
- Check and create the gist badge file if missing
- Populate all badge URLs pointing to the current repository
- Produce terraform-docs-compatible inputs/outputs tables
- Follow markdownlint rules (MD060 table column style)
