module "dataproc_cluster" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  dataproc_cluster_config = {
    base_name             = var.base_name
    service_account_email = var.service_account_email
  }
}
