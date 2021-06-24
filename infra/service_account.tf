resource "google_service_account" "service_account" {
  account_id   = "insane-service-account"
  display_name = "Insane service account"
  project = "insane_project"
}

resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}