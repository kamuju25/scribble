To connect to EKS cluster from the ec2 instance -

Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) on the Linux server, install the AWS CLI, and then run `aws configure` to authenticate with AWS so you can launch and access resources.

```bash
aws eks update-kubeconfig --name <cluster-name> --region <region>
```
This will update the kube config configuration on the ec2 instance, we will use the auto mode eks which comes with karepenter installed, that takes care of provisioning worker nodes for the eks cluster based on the load.
