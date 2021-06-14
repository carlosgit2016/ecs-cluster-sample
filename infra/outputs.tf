output service_account_private_key {
  value       = google_service_account_key.mykey.private_key
  sensitive   = true
  description = "Service Account private key"
}

output service_account_name {
  value       = google_service_account.service_account.name
  description = "Service Account Name"
}
