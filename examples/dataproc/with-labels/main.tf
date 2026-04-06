module "dataproc_cluster" {
  source = "../../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  dataproc_cluster_config = {
    base_name = var.base_name
    labels = {
      env         = "devl"
      team        = "data-eng"
      cost-centre = "analytics"
    }
  }
}
