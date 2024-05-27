resource "google_service_account_iam_member" "deploy-iam-token-accessor" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${local.deploy_sa}"
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${local.deploy_sa}"
}

data "google_service_account_access_token" "default" {
  target_service_account = local.deploy_sa
  scopes                 = ["cloud-platform"]
  lifetime               = "300s"

  depends_on = [google_service_account_iam_member.deploy-iam-token-accessor]
}

# -- REST API provider for Access Management API endpoints
provider "restapi" {
  alias = "accessmanagement"
  uri   = local.restapi_am
  headers = {
    "Authorization" : "Bearer ${data.google_service_account_access_token.default.access_token}"
  }
  write_returns_object = true
}

# -- provided configurations for subscriptions
resource "restapi_object" "accessmanagement_subscriptions" {
  force_new = [join("", [for s in local.path_audit_force_reload : md5(file("${path.module}/../../../${s}"))])]
  provider  = restapi.accessmanagement

  for_each = {
    for filepath, config in local.subscription_configurations :
    # add the rule id to the for_each key to ensure that changing rule_id
    # will delete and re-create the subscription
    "rules/${config.rule_id}/${filepath}" => config
  }
  path         = "/v1/rules/${each.value.rule_id}/subscriptions"
  data         = jsonencode(each.value.subscription)
  id_attribute = "data/id"
}
