## Project Configuration

### Services

- Configure Virtual env python

```bash
pip install virtualenv
virtualenv my-env
source my-env/bin/activate
my-env/bin/pip install google-cloud-pubsub
```

### IaC
- Install gcloud cli
- Authenticate on gcloud to initiate a new context with terraform
```bash
gcloud auth application-default login
```
- Configure the provider block, get the project id from [Manager Console](https://console.cloud.google.com/cloud-resource-manager)
```terraform
provider "google" {
  project = "eld-efs-sandbox-5576df8f"
  region  = "us-central1"
}
```