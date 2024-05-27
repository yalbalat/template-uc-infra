locals {
  general_config  = yamldecode(templatefile("${var.config_path}/general.yaml", { env = var.env }))
  dataform_config = jsondecode(file(var.dataform_config_file))

  region                   = local.general_config["region"]
  location                 = local.dataform_config["defaultLocation"]
  dataform_git_url         = local.general_config["git_repository_url"]
  dataform_repository_name = local.general_config["git_repository_name"]
  dataform_scheduler_cron  = lookup(local.general_config, "dataform_scheduler_cron", "")
  usecase                  = replace(local.dataform_config["vars"]["use_case"], "_", "-")
  deploy_sa                = "${local.usecase}-sa-cloudbuild-${var.env}@${var.project_id}.iam.gserviceaccount.com"

  bigquery_datasets_short_names         = local.general_config["bigquery"]["datasets_short_names"]
  bigquery_reporting_dataset_short_name = local.general_config["bigquery"]["reporting_dataset_short_name"]
  bigquery_reporting_dataset_users      = local.general_config["bigquery"]["reporting_dataset_users"]

  # # Event driven
  # warehouses_source_project                       = local.general_config["event_driven"]["warehouses_source_project"]
  # successful_reload_warehouse_topics_to_subscribe = local.general_config["event_driven"]["successful_reload_warehouse_topics_to_subscribe"]
}
