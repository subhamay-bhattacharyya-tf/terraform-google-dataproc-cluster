# ============================================================================
# Dataproc Cluster Module - Main
# Creates and manages a Google Cloud Dataproc cluster.
# ============================================================================

resource "google_dataproc_cluster" "this" {
  name   = local.cluster_name
  region = var.region
  labels = var.dataproc_cluster_config.labels

  cluster_config {
    software_config {
      image_version       = var.dataproc_cluster_config.image_version
      optional_components = var.dataproc_cluster_config.optional_components
    }

    master_config {
      num_instances = var.dataproc_cluster_config.master_num_instances
      machine_type  = var.dataproc_cluster_config.master_machine_type
      disk_config {
        boot_disk_size_gb = var.dataproc_cluster_config.master_disk_size_gb
      }
    }

    worker_config {
      num_instances = var.dataproc_cluster_config.worker_num_instances
      machine_type  = var.dataproc_cluster_config.worker_machine_type
      disk_config {
        boot_disk_size_gb = var.dataproc_cluster_config.worker_disk_size_gb
      }
    }

    # Preemptible workers — only created when count > 0
    dynamic "preemptible_worker_config" {
      for_each = var.dataproc_cluster_config.preemptible_worker_num_instances > 0 ? [1] : []
      content {
        num_instances = var.dataproc_cluster_config.preemptible_worker_num_instances
      }
    }

    # Network / service account placement — only set when at least one is provided
    dynamic "gce_cluster_config" {
      for_each = (
        var.dataproc_cluster_config.network != null ||
        var.dataproc_cluster_config.subnetwork != null ||
        var.dataproc_cluster_config.service_account_email != null
      ) ? [1] : []
      content {
        network         = var.dataproc_cluster_config.network
        subnetwork      = var.dataproc_cluster_config.subnetwork
        service_account = var.dataproc_cluster_config.service_account_email
      }
    }

    # Web UI access (Yarn, Spark History Server, etc.)
    dynamic "endpoint_config" {
      for_each = var.dataproc_cluster_config.enable_http_port_access ? [1] : []
      content {
        enable_http_port_access = true
      }
    }

    # Auto-delete when idle — only set when idle_delete_ttl is provided
    dynamic "lifecycle_config" {
      for_each = var.dataproc_cluster_config.idle_delete_ttl != null ? [1] : []
      content {
        idle_delete_ttl = var.dataproc_cluster_config.idle_delete_ttl
      }
    }
  }
}
