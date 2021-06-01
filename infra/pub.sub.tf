locals {
  tags = {
    owner = "devops"
    terraform = true
  }
}


resource "google_pubsub_topic" "example" {
  name = "insane-topic"
  project = "eld-efs-sandbox-5576df8f"

  labels = local.tags
}

resource "google_pubsub_subscription" "example" {
  name  = "insane-subscription"
  topic = google_pubsub_topic.example.name

  ack_deadline_seconds = 20

  labels = local.tags
}