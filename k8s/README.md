To connect to EKS cluster from the ec2 instance -

Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) on the Linux server, install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), and then run `aws configure` to authenticate with AWS so you can launch and access resources.

```bash
aws eks update-kubeconfig --name <cluster-name> --region <region>
```
This will update the kube config configuration on the ec2 instance, we will use the auto mode eks which comes with karepenter installed, that takes care of provisioning worker nodes for the eks cluster based on the load.

Navigate to the Scribble directory and then to k8s folder, then run -

```bash
kubectl apply -f scribble.yml
```
You can now run kubectl get pods to verify the pods, or check the same from the AWS Console under the EKS service.

To verify -

```bash
kubectl get svc -n scribble
```

If you are connected to AWS CLI from an ec2 instance then change the frontend service to LoadBalancer and access it in the browser using -

```bash
http://<external-dns-ip>
```

If you are connected to AWS CLI and EKS from your local machine, run this command to access the application in your browser.

```bash
kubectl port-forward svc/scribble-frontend 8172:80 -n scribble --address 0.0.0.0
```


## Install and Configure Argo CD

You can follow the official documentation: [Argo-CD](https://argo-cd.readthedocs.io/en/stable/getting_started/)

To check if argocd is installed 
```bash
kubectl get all -n argocd
```
Run
```bash
kubectl get secrets -n argocd
```
Look for `argocd-initial-admin-secret` and by running `kubectl edit secret argocd-initial-admin-secret` to fetch the secret. The password will be in base64 encoded format — to decode it, run `echo <password> | base64 --decode` 

Also run.
```bash
kubectl get svc -n argocd
```

Here we are using kubectl port-forward to access ArgoCD, however this can also be done by exposing it via an Ingress or a LoadBalancer service.

```bash
kubectl port-forward svc/argocd-server <port>:<argocd-server-port> -n argocd --address 0.0.0.0
```

You can now access ArgoCD at `http://localhost:<port>`. Use the decoded base64 password from earlier to log in. Once logged in, you can configure ArgoCD to automatically sync and deploy to the EKS cluster whenever a Kubernetes manifest file is updated in your Git repository. This pattern is called GitOps.
