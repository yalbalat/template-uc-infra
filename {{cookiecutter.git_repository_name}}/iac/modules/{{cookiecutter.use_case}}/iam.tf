resource "google_bigquery_dataset_iam_member" "bigquery_reporting_viewers" {
  for_each   = toset(local.bigquery_reporting_dataset_users)
  project    = var.project_id
  dataset_id = "d_${replace(local.usecase, "-", "_")}_${local.bigquery_reporting_dataset_short_name}_${lower(local.location)}_${var.env}"
  role       = "roles/bigquery.dataViewer"
  member     = each.key
}

resource "google_project_iam_member" "bigquery_job_users" {
  for_each = toset(local.bigquery_reporting_dataset_users)
  project  = var.project_id
  role     = "roles/bigquery.jobUser"
  member   = each.key
}

resource "google_project_iam_member" "bigquery_read_session_users" {
  for_each = toset(local.bigquery_reporting_dataset_users)
  project  = var.project_id
  role     = "roles/bigquery.readSessionUser"
  member   = each.key
}

resource "google_service_account_iam_member" "deploy-iam-sa-user" {
  # Deploy sa needs to be sa user to deploy the Dataform executor sworkflow
  service_account_id = module.dataform_provider.dataform_executor_sa_name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${local.deploy_sa}"
}

# # Event driven IAM

# resource "google_service_account" "pubsub-to-workflow-run-invoker" {
#   account_id   = "pubsub-to-workflow-run-invoker"
#   display_name = ""
#   description  = ""
# }

# resource "google_cloud_run_service_iam_member" "pubsub_to_workflow_run_invoker" {
#   location = local.region
#   project  = var.project_id
#   service  = google_cloud_run_service.pubsub-to-workflow.name
#   role     = "roles/run.invoker"
#   member   = "serviceAccount:${google_service_account.pubsub-to-workflow-run-invoker.email}"
# }

# resource "google_service_account" "pubsub-to-workflow-run" {
#   account_id   = "pubsub-to-workflow-run"
#   display_name = ""
#   description  = ""
# }

# resource "google_project_iam_member" "pubsub-to-workflow-run-workflow-invoker" {
#   project = var.project_id
#   role    = "roles/workflows.invoker"
#   member  = "serviceAccount:${google_service_account.pubsub-to-workflow-run.email}"
# }

# resource "google_project_iam_member" "pubsub-to-workflow-run-firestore-iam" {
#   project = var.project_id
#   role    = "roles/datastore.user"
#   member  = "serviceAccount:${google_service_account.pubsub-to-workflow-run.email}"
# }
