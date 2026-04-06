# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this module does

This is a **Terraform module** that creates and manages a single `google_dataproc_cluster` resource on GCP. The entire public interface is one input variable (`dataproc_cluster_config`) and outputs covering key cluster attributes (id, name, project, region, master_instance_names, worker_instance_names, http_ports). This will be used as a GitHub Repository Template. The actual modules will be implemented separately.

## Common commands

```bash
# Format check (must pass before commit)
terraform fmt -check -recursive

# Validate root module
terraform init -backend=false && terraform validate

# Validate the example
cd examples/dataproc/basic && terraform init -backend=false && terraform validate

# Run Terratest integration test (requires GCP auth + GOOGLE_CLOUD_PROJECT env var)
cd test && go test -v -timeout 30m -run TestDataprocClusterBasic ./dataproc_cluster_basic_test.go ./helpers_test.go

# Install local dev tools (Linux/devcontainer only)
bash install-tools.sh
bash install-tools.sh --tools=terraform,tflint,trivy  # install subset
bash install-tools.sh --dry-run                        # preview only

# Run pre-commit hooks
pre-commit run --all-files
```

## Architecture

```text
.                      # Root module — the publishable Terraform module
├── main.tf            # Single google_dataproc_cluster resource
├── variables.tf       # dataproc_cluster_config object variable with all validations
├── outputs.tf         # Cluster attribute outputs (id, name, project, region, cluster_uuid, etc.)
├── versions.tf        # Terraform >= 1.3.0, google provider >= 7.23.0
├── examples/
│   └── dataproc/basic/  # Reference usage; CI validates this separately
└── test/
    ├── dataproc_cluster_basic_test.go   # Terratest: creates real cluster, asserts outputs, destroys
    └── helpers_test.go                  # Shared test helpers
```

## Key Conventions

- Terraform files use `/` directory with standard layout (main.tf, variables.tf, outputs.tf)
- GitHub Actions uses OIDC — no stored service account keys
- All infrastructure changes go through Terraform — never modify GCP resources manually
- This Terraform module only accepts one input of object type

The module uses a single structured `dataproc_cluster_config` object rather than flat variables. All validation (naming rules, region/zone format, machine type values, project ID format) lives in `variables.tf`.

## CI pipeline (`.github/workflows/ci.yaml`)

Runs on pushes/PRs to `main`, `feature/**`, `bug/**` when `.tf`, `examples/**`, or `test/**` files change:

1. **terraform-validate** — `fmt -check`, `init`, `validate` on the root module
2. **examples-validate** — `init` + `validate` on `examples/dataproc/basic` (needs step 1)
3. **terratest** — real GCP integration test via Workload Identity Federation (needs step 2); requires `GCP_PROJECT_ID`, `GCP_WORKLOAD_IDENTITY_PROVIDER`, `GCP_SERVICE_ACCOUNT` repo vars
4. **generate-changelog** — runs `git-cliff` on non-main branches (needs step 2)
5. **semantic-release** — runs only on `main` after steps 2 and 3; uses Conventional Commits to auto-version

## Commit message convention

Follows **Conventional Commits** — semantic-release uses this to determine the next version:

- `feat:` → minor bump
- `fix:` → patch bump
- `chore:`, `docs:`, `refactor:`, etc. → no release
- Breaking changes via `BREAKING CHANGE:` footer → major bump

## Known inconsistencies (leftover from template)

- `README.md` describes a GCS bucket module (`google_storage_bucket`) — stale, needs rewriting for `google_dataproc_cluster`.
- `main.tf`, `variables.tf`, and `outputs.tf` still implement GCS bucket logic — need full replacement with Dataproc cluster resources and variables.
- `test/gcs_bucket_basic_test.go` tests GCS bucket creation (`TestGCSBucketBasic`) — needs replacing with a Dataproc cluster test (`dataproc_cluster_basic_test.go`).
- `test/helpers_test.go` uses `cloud.google.com/go/storage` GCS client helpers — needs replacing with Dataproc-specific helpers using the Dataproc client library.
- `test/go.mod` module path references the old template repo name and declares `cloud.google.com/go/storage` as a dependency — the path and dependency should be updated for Dataproc.
- `examples/bucket/` directory needs replacing with `examples/dataproc/`.
