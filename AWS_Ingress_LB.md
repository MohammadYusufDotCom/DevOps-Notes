## How to install nginx ingress congtroller in aws and connect with existing load balancer

## Pre-requisite-1: Create EKS Cluster and Worker Nodes (if not created).
```t
# Create Cluster
eksctl create cluster --name=eksdemo1 \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --version="1.21" \
                      --without-nodegroup 


# Get List of clusters (Section-01-02)
eksctl get cluster   

# Template 
# Replace with region & cluster name 
eksctl utils associate-iam-oidc-provider \
    --region region-code \
    --cluster <cluter-name> \
    --approve

# Create EKS NodeGroup in VPC Private Subnets
eksctl create nodegroup --cluster=eksdemo1 \
                        --region=us-east-1 \
                        --name=eksdemo1-ng-private1 \
                        --node-type=t3.medium \
                        --nodes-min=2 \
                        --nodes-max=4 \
                        --node-volume-size=20 \
                        --ssh-access \
                        --ssh-public-key=kube-demo \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access \
                        --node-private-networking       
```

## Step-02: Install AWS Load Balancer Controller
- [Get Region Code and Account info](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)
- Or you can simply keep images public.ecr.aws/eks/aws-load-balancer-controller:v2.9.0 or simply leave this flag
```t
# Add the eks-charts repository.
helm repo add eks https://aws.github.io/eks-charts

# Install the AWS Load Balancer Controller.
# Template
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region-code> \
  --set vpcId=<vpc-xxxxxxxx> \
  --set image.repository=<account>.dkr.ecr.<region-code>.amazonaws.com/amazon/aws-load-balancer-controller

## keep serviceAccount.create=true if have not created service account on your own
```
## Step 03: Install Nginx ingress controller
```t
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm -n ingress install ingress-nginx ingress-nginx/ingress-nginx -f values.yaml
```
- values.yaml file file content
```
controller:
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-arn: <arn of your loadbalancer>
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: instance
      service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    type: LoadBalancer
```
*Note:* also add below tags to your existing load balancer
```
elbv2.k8s.aws/cluster: <cluster name>
service.k8s.aws/resource: LoadBalancer
service.k8s.aws/stack: ingress/ingress-nginx-controtler
```

## Addtional data you can use while installing ingress controller with AWS SSL 
```t
## Pass these vaules during the helm installation part as ==> -f value2.yaml
## this is file is for public ALB and with certificate

controller:
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: instance
      service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-east-1:339713103209:certificate/a6bb7576-3b17-4ae6-934d-fe8196af34a3
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: 443
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
    type: LoadBalancer
```
