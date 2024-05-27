resource "google_bigquery_dataset" "usecase_bigquery_datasets" {
  for_each   = toset(local.bigquery_datasets_short_names)
  project    = var.project_id
  dataset_id = "d_${replace(local.usecase, "-", "_")}_${each.key}_${lower(local.location)}_${var.env}"
  location   = local.location
}

resource "google_bigquery_dataset" "usecase_reporting_bigquery_dataset" {
  project    = var.project_id
  dataset_id = "d_${replace(local.usecase, "-", "_")}_${local.bigquery_reporting_dataset_short_name}_${lower(local.location)}_${var.env}"
  location   = local.location

  max_time_travel_hours      = 168
  delete_contents_on_destroy = false
}
