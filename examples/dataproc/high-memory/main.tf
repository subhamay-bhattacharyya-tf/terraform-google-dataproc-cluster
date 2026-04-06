module "dataproc_cluster" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  dataproc_cluster_config = {
    base_name           = var.base_name
    master_machine_type = "n1-highmem-8"
    worker_machine_type = "n1-highmem-8"
  }
}
