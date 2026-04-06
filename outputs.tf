# ============================================================================
# Dataproc Cluster Module - Outputs
# ============================================================================

output "cluster_id" {
  description = "The fully-qualified resource ID of the Dataproc cluster."
  value       = google_dataproc_cluster.this.id
}

output "cluster_name" {
  description = "The name of the Dataproc cluster."
  value       = google_dataproc_cluster.this.name
}

output "cluster_project" {
  description = "The GCP project in which the cluster was created."
  value       = google_dataproc_cluster.this.project
}

output "cluster_region" {
  description = "The GCP region of the cluster."
  value       = google_dataproc_cluster.this.region
}

output "master_instance_names" {
  description = "List of master node instance names."
  value       = google_dataproc_cluster.this.cluster_config[0].master_config[0].instance_names
}

output "worker_instance_names" {
  description = "List of primary worker node instance names."
  value       = google_dataproc_cluster.this.cluster_config[0].worker_config[0].instance_names
}

output "http_ports" {
  description = "Map of component web UI ports exposed on the cluster (e.g. Yarn, Spark History Server)."
  value       = length(google_dataproc_cluster.this.cluster_config[0].endpoint_config) > 0 ? google_dataproc_cluster.this.cluster_config[0].endpoint_config[0].http_ports : {}
}
