# ============================================================================
# Dataproc Cluster Module - Locals
# ============================================================================

locals {
  cluster_name = "${var.project_code}-${var.dataproc_cluster_config.base_name}-${var.region}-${var.environment}"
}
