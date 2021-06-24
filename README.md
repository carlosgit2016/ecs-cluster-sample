## Project Configuration

Proof of concept to a clustered application to subscribe/publish in gcloud PubSub.

### Pre requisites
- [Terraform](https://www.terraform.io/downloads.html)
- [Python3](https://www.python.org/downloads/)
- [Gcloud CLI](https://cloud.google.com/sdk/gcloud)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
> All those tools are available to configure via [asdf](https://github.com/asdf-vm/asdf)
### Developing

- Configure Virtual env python

```bash
pip install virtualenv
virtualenv my-env
source my-env/bin/activate
my-env/bin/pip install google-cloud-pubsub
```

### IaC Google cloud
- Install gcloud cli
- Authenticate on gcloud to initiate a new context with terraform
```bash
gcloud auth application-default login
```
- Configure the provider block, get the project id from [Manager Console](https://console.cloud.google.com/cloud-resource-manager)
```terraform
provider "google" {
  project = "insane_project"
  region  = "us-central1"
}
```
> You can also create the project using [terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project)
- Plan/Apply the infrastructure with terraform
  - `cd infra`
  - `terraform plan`
  - `terraform apply`

### Authentication for PubSub
Once the images on this project would publish/subscribe on topics outside a gcloud VPC, you should load the `google-insane-key.json` with the necessary permissions in your local machine in the `src` level of the project. `src/google-insane-key.json`

### Docker images
You can build the docker images running `docker build -t publisher:1.0.0 --file publisher/Dockerfile` for both images `publisher` and `subscriber`. 

### Cluster
This project is using [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) to configure the cluster in you local machine. 

To initiate run `kind create cluster --config cluster/kind-cluster-sample.yml`, it is necessary to have Docker in your local machine, then kind will create a new container that will be your cluster and publish certain ports that can be configured on the configuration file.

It is necessary to load the builded images inside the cluster, to do that run `kind load docker-image publisher:1.0.0` and `kind load docker-image subscriber:1.0.0`, It will make the images accessible when creating the resources on k8s that will depend of it.

### K8s configuration
The configuration for kubernetes resources is present in `src/k8s-manifest.yml` and can be applied on the cluster using `kubectl apply -f src/k8s-manifest.yml`. Important things around the resources:

- One pod that cointains both containers to publish and subscribe to gcloud PubSub topics
- One NodePort service that is used to expose our pod for outside our cluster and made it accessible via http://<node_ip>:<service_node_port>
- You can also create a port-forwarding to access the pod instead of accessing it via the node ip, run `kubectl port-forward service/my-service 30006:6895`

Obs:. The port mapping is present on the cluster configuration too, once it is a container running simulating the cluster.

### Application
The publisher is build in flask and when running should listen on the configured port, when receiving requests through the configured path it will publish in the configured topic on gcloud. You can change the topic that is hardcoded on `src/publisher/publisher.py`

The subscriber follow the same publisher logic but it subscribes in a specific subscription on gcloud, you can change which subscription it should subscribe on `src/subscriber/subscriber.py`

### Example of execution
On the root project level folder

Build the images
```
docker build -t publisher:1.0.0 --file publisher/Dockerfile .
docker build -t subscriber:1.0.0 --file subscriber/Dockerfile .
```

Create the cluster
```
kind create cluster --config cluster/kind-cluster-sample.yml
```

Load the images on cluster
```
kind load docker-image publisher:1.0.0
kind load docker-image subscriber:1.0.0
```

Configure the context
```
kubectl cluster-info --context kind-kind
```

Apply the k8s manifest
```
kubectl apply -f src/k8s-manifest.yml
```

Watch the resources creation/deploying 
```
kubectl get all
```

