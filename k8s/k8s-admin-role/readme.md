# How to create RBAC for k8s

✅ Step 1: Create a Private Key and CSR for the User
```t
openssl genrsa -out <username>.key 2048

openssl req -new -key <username>.key -out <username>.csr -subj "/CN=<username>/O=<group>"
```

Step 2: Sign the CSR with the Kubernetes CA
```

```

✅ Step 3: Create the Kubernetes Role or ClusterRole
```t
# clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

