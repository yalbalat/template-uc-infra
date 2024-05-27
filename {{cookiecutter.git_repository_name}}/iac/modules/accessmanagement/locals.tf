locals {
  # import configurations
  general_config  = yamldecode(file("${var.config_path}/general.yaml"))
  dataform_config = jsondecode(file(var.dataform_config_file))
  usecase         = replace(local.dataform_config["vars"]["use_case"], "_", "-")
  deploy_sa       = "${local.usecase}-sa-cloudbuild-${var.env}@${var.project_id}.iam.gserviceaccount.com"

  path_audit_force_reload = local.general_config["access_management"]["path_audit_force_reload"]
  accessmanagement_folder = "${path.module}/../../../config/subscriptions"
  restapi_am              = "https://api.loreal.net/global/it4it/btdp-rulemanager"
  subscription_configurations = {
    for filepath in fileset(local.accessmanagement_folder, "*.yaml") :
    filepath => yamldecode(
      templatefile(
        "${local.accessmanagement_folder}/${filepath}", { project_env = var.env, project_id = var.project_id }
      )
    )
  }
}
