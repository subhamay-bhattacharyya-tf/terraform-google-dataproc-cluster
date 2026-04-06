module "dataproc_cluster" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  dataproc_cluster_config = {
    base_name                        = var.base_name
    image_version                    = "2.1-debian11"
    master_machine_type              = "n1-highmem-8"
    master_num_instances             = 3
    master_disk_size_gb              = 200
    worker_machine_type              = "n1-highmem-8"
    worker_num_instances             = 4
    worker_disk_size_gb              = 200
    preemptible_worker_num_instances = 2
    network                          = var.network
    subnetwork                       = var.subnetwork
    service_account_email            = var.service_account_email
    enable_http_port_access          = true
    idle_delete_ttl                  = "3600s"
    optional_components              = ["JUPYTER", "ZEPPELIN"]
    labels = {
      env         = var.environment
      team        = "data-eng"
      cost-centre = "analytics"
    }
  }
}
