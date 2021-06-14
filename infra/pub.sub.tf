locals {
  tags = {
    owner = "devops"
    terraform = true
  }
}


resource "google_pubsub_topic" "example" {
  name = "insane-topic"

  labels = local.tags
}

resource "google_pubsub_subscription" "example" {
  name  = "insane-subscription"
  topic = google_pubsub_topic.example.name

  ack_deadline_seconds = 20

  labels = local.tags
}

# Role. A role is a collection of permissions. Permissions determine what operations are allowed on a resource. When you grant a role to a member, you grant all the permissions that the role contains.
# Policy. The IAM policy is a collection of role bindings that bind one or more members to individual roles. When you want to define who (member) has what type of access (role) on a resource, you create a policy and attach it to the resource.

resource "google_project_iam_custom_role" "insanepublisher" {
  role_id     = "insanepublisher"
  title       = "Insane pubsub publisher role"
  description = "Insane"
  permissions = [
    "pubsub.topics.publish",
    "pubsub.subscriptions.consume"
  ]
}

resource "google_project_iam_custom_role" "insanesubscription" {
  role_id     = "insanesubscription"
  title       = "Insane pubsub subscription role"
  description = "Insane"
  permissions = [
    "pubsub.subscriptions.consume"
  ]
}

# It retrieve the IAM policy that contain the role and the members to associate with
data "google_iam_policy" "policy_data_pubsub" {
  binding {
    role = google_project_iam_custom_role.insanepublisher.name
    members = [
      "serviceAccount:${google_service_account.service_account.email}",
    ]
  }
}

data "google_iam_policy" "policy_data_pubsub_sub" {
  binding {
    role = google_project_iam_custom_role.insanesubscription.name
    members = [
      "serviceAccount:${google_service_account.service_account.email}",
    ]
  }
}

# This is adding the member and the role through the policy_data that was created above 
resource "google_pubsub_topic_iam_policy" "policy_for_topic" {
  topic = google_pubsub_topic.example.name
  policy_data = data.google_iam_policy.policy_data_pubsub.policy_data
}

resource "google_pubsub_subscription_iam_policy" "policy_for_sub" {
  subscription = google_pubsub_subscription.example.name
  policy_data = data.google_iam_policy.policy_data_pubsub_sub.policy_data
}