To connect to EKS cluster from the ec2 instance -

First install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) on the linux server.

```bash
aws eks update-kubeconfig --name <cluster-name> --region <region>
```
This will update the kube config configuration on the ec2 instance, we will use the auto mode eks which comes with karepenter installed, that takes care of provisioning worker nodes for the eks cluster based on the load.