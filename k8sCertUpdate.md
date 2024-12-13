# to check the expiry of cert 

### To check the certificate expiry 
```t
sudo kubeadm certs check-expiration

## or you can check manually expiry of the each certcicate

openssl x509 -in /etc/kubernetes/ca.crt -noout -enddate
```

### Renew all the certificate using the belokw command
```t
sudo kubeadm certs renew all
```

### Now you need to restart pods which are using the ccert 

Note: kube-apiserver, kube-scheduler, kube-controller-manager, and etcd containers.

```t
sudo crictl ps | grep CONTAINER_NAME
sudo crictl stop CONTAINER_ID
```

#### Or you can restart static pods which are present on below path
```
mv /etc/kubernetes/manifests /etc/kubernetes/manifests_bkp
mv /etc/kubernetes/manifests_bkp /etc/kubernetes/manifests
```

Veryfi if everthig is working fine
kubectl get nodes --kubeconfig=/etc/kubernetes/admin.conf

If you want to create a new kubeconfig file
```
kubectl  --kubeconfig=”ADMIN_KUBECONFIG” get secret/CLUSTER_NAME-kubeconfig -n “CLUSTER_NAMESPACE” -o jsonpath=’{.data.value}’ | base64 — decode > new_kubeconfig.conf
```
