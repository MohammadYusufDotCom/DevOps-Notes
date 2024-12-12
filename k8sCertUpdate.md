# to check the expiry of cert 

sudo kubeadm certs check-expiration

openssl x509 -in /etc/kubernetes/ca.crt -noout -enddate


files are /etc/kubernetes/manifests should are static need to be restart and backup first and replace same again
   # OR 
restart kube-apiserver, kube-scheduler, kube-controller-manager, and etcd containers.

sudo crictl ps | grep CONTAINER_NAME
sudo crictl stop CONTAINER_ID


now kubeconfig file will be 
/etc/kubernetes/admin.conf


renew certificate
sudo kubeadm certs renew all



veryfi if everthi is working fine
kubectl get nodes --kubeconfig=/etc/kubernetes/admin.conf



if you want to create a new kubeconfig file
kubectl — kubeconfig=”ADMIN_KUBECONFIG” get secret/CLUSTER_NAME-kubeconfig -n “CLUSTER_NAMESPACE” -o jsonpath=’{.data.value}’ | base64 — decode > new_kubeconfig.conf

