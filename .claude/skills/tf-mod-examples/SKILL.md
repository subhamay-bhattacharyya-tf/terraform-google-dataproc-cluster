---
name: tf-mod-examples
description: >
  Generates Terraform module example configurations covering all meaningful
  combinations of input variables. Use this skill when the user asks to
  generate examples, scaffold example directories, create tfvars combinations,
  or produce a complete examples/ folder for a Terraform module. Trigger when
  the user says "generate all examples", "scaffold examples", "create example
  combinations", or "fill in the examples directory". Also trigger when the
  user shares a variables.tf and asks for example usage across all options.
---

# Terraform Module Examples — Generator Skill

This skill generates a complete `examples/` directory tree for a Terraform
module by reading `variables.tf` and producing one standalone example per
meaningful feature combination.

---

## How to Use This Skill

1. Read `variables.tf` (and `versions.tf` if present) from the current module root.
2. Identify every optional field and enumerate its allowed values from `validation` blocks or type annotations.
3. Derive the example matrix using the rules below.
4. Write each example as a self-contained directory under `examples/dataproc/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

---

## Step 1 — Enumerate Axes

For each optional field in the root `dataproc_cluster_config` object, record:

| Axis | Values |
|---|---|
| `master_machine_type` | `n1-standard-4`, `n1-standard-8`, `n1-highmem-4`, `n1-highmem-8` |
| `worker_machine_type` | `n1-standard-4`, `n1-standard-8`, `n1-highmem-4`, `n1-highmem-8` |
| `master_num_instances` | `1` (standard), `3` (HA) |
| `worker_num_instances` | `2` (minimum), `4`, `8` |
| `preemptible_worker_num_instances` | `0` (absent), `2`, `4` |
| `image_version` | `2.1-debian11`, `2.2-debian12`, `2.1-ubuntu20` |
| `optional_components` | absent, `["JUPYTER"]`, `["JUPYTER", "ZEPPELIN"]` |
| `idle_delete_ttl` | absent, `"1800s"`, `"3600s"` |
| `enable_http_port_access` | `true`, `false` |
| `network` / `subnetwork` | absent, present (custom VPC) |
| `service_account_email` | absent, present |
| `labels` | absent, present |

---

## Step 2 — Example Matrix

Do **not** generate the full cartesian product. Instead produce these named
examples, each exercising a distinct capability or realistic deployment pattern:

| Directory | Purpose | Key axes exercised |
|---|---|---|
| `basic/` | Minimal cluster, all defaults | 1 master, 2 workers, default machine types |
| `high-availability/` | HA master configuration | `master_num_instances=3` |
| `high-memory/` | Memory-optimized nodes | `master_machine_type=n1-highmem-8`, `worker_machine_type=n1-highmem-8` |
| `with-preemptible-workers/` | Cost-optimised with spot/preemptible workers | `preemptible_worker_num_instances=4` |
| `with-jupyter/` | Jupyter notebook component | `optional_components=["JUPYTER"]`, `enable_http_port_access=true` |
| `with-optional-components/` | Multiple Spark ecosystem components | `optional_components=["JUPYTER","ZEPPELIN"]` |
| `with-custom-network/` | Cluster in specific VPC and subnet | `network`, `subnetwork` set |
| `with-lifecycle/` | Auto-delete cluster when idle | `idle_delete_ttl="3600s"` |
| `with-service-account/` | Custom node service account | `service_account_email` set |
| `with-labels/` | Resource labelling for cost attribution | `labels` map with env/team/cost-centre |
| `complete/` | All features combined | HA, highmem, preemptibles, jupyter, custom network, lifecycle, labels |

---

## Step 3 — File Structure per Example

Each example directory must contain exactly these four files:

```
examples/dataproc/<name>/
├── main.tf            # module call block only — no provider block
├── variables.tf       # re-declare only the variables consumed in main.tf
├── terraform.tfvars   # concrete values for every variable in variables.tf
└── README.md          # one-paragraph description + usage snippet
```

### `main.tf` template

```hcl
module "<name>" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  dataproc_cluster_config = {
    base_name = var.base_name
    # ... only include fields relevant to this example
  }
}
```

### `variables.tf` template

```hcl
variable "environment"  { type = string }
variable "project_code" { type = string }
variable "region"       { type = string  default = "us-central1" }
variable "base_name"    { type = string }
```

### `terraform.tfvars` template

```hcl
environment  = "devl"
project_code = "demo"
region       = "us-central1"
base_name    = "<example-slug>"
```

### `README.md` template

```markdown
# <Example Title>

One sentence describing what this example demonstrates.

## Usage

\`\`\`bash
terraform init -backend=false
terraform validate
\`\`\`
```

---

## Step 4 — Validation Rules

After writing all files:

1. Run `terraform fmt -recursive examples/` to format all generated files.
2. Run `terraform init -backend=false && terraform validate` inside each example directory and report any errors.
3. Fix any errors before returning.

---

## Step 5 — Output Summary

After all files are written and validated, print a table:

| Example | Files written | Validated |
|---|---|---|
| `basic/` | 4 | ✓ |
| ... | ... | ... |
