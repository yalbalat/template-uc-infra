module "dataform_provider" {
  source                         = "app.terraform.io/oa-emea/dataform-provider/google"
  version                        = "4.0.2"
  project_id                     = var.project_id
  env                            = var.env
  region                         = local.region
  dataform_git_url               = local.dataform_git_url
  dataform_default_branch        = var.env == "pd" ? "main" : "integration"
  dataform_repository_name       = local.dataform_repository_name
  scheduler_cron                 = var.env == "dv" ? "" : local.dataform_scheduler_cron
  usecase                        = local.usecase
  is_deploy_sa_project_iam_admin = false
}
