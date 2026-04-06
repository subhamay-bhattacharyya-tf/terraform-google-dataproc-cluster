# ============================================================================
# Dataproc Cluster Module - Variables
# ============================================================================

variable "environment" {
  description = "Deployment environment. One of: devl, test, prod."
  type        = string

  validation {
    condition     = contains(["devl", "test", "prod"], var.environment)
    error_message = "environment must be one of: devl, test, prod."
  }
}

variable "project_code" {
  description = "Short project identifier used as a prefix in resource naming."
  type        = string

  validation {
    condition     = length(var.project_code) > 0
    error_message = "project_code must not be empty."
  }
}

variable "region" {
  description = "GCP region where the Dataproc cluster will be created."
  type        = string
  default     = "us-central1"
}

variable "dataproc_cluster_config" {
  description = "Configuration object for the Google Dataproc cluster."
  type = object({
    base_name                        = string
    image_version                    = optional(string, "2.1-debian11")
    master_machine_type              = optional(string, "n1-standard-4")
    master_num_instances             = optional(number, 1)
    master_disk_size_gb              = optional(number, 100)
    worker_machine_type              = optional(string, "n1-standard-4")
    worker_num_instances             = optional(number, 2)
    worker_disk_size_gb              = optional(number, 100)
    preemptible_worker_num_instances = optional(number, 0)
    network                          = optional(string, null)
    subnetwork                       = optional(string, null)
    service_account_email            = optional(string, null)
    enable_http_port_access          = optional(bool, true)
    idle_delete_ttl                  = optional(string, null)
    optional_components              = optional(list(string), [])
    labels                           = optional(map(string), {})
  })

  validation {
    condition     = length(var.dataproc_cluster_config.base_name) > 0 && length(var.dataproc_cluster_config.base_name) <= 30
    error_message = "base_name must be between 1 and 30 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.dataproc_cluster_config.base_name))
    error_message = "base_name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = contains([1, 3], var.dataproc_cluster_config.master_num_instances)
    error_message = "master_num_instances must be 1 (standard) or 3 (high availability)."
  }

  validation {
    condition     = var.dataproc_cluster_config.worker_num_instances >= 2
    error_message = "worker_num_instances must be at least 2."
  }

  validation {
    condition     = var.dataproc_cluster_config.master_disk_size_gb >= 10
    error_message = "master_disk_size_gb must be at least 10 GB."
  }

  validation {
    condition     = var.dataproc_cluster_config.worker_disk_size_gb >= 10
    error_message = "worker_disk_size_gb must be at least 10 GB."
  }

  validation {
    condition     = var.dataproc_cluster_config.preemptible_worker_num_instances >= 0
    error_message = "preemptible_worker_num_instances must be 0 or greater."
  }
}
