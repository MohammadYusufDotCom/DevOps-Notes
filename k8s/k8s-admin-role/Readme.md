# How to make RBAC

✅ Step 1: Create a Private Key and CSR for the User


```t
openssl genrsa -out <username>.key 2048

openssl req -new -key <username>.key -out <username>.csr -subj "/CN=<username>/O=<group>"
```

✅ Step 2: Sign the CSR with the Kubernetes CA

```
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: techops
spec:
  request: <Base64 encoded csr>
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 31556952
  usages:
    - client auth
```

✅ Step 3: Convert your csr in base64 
```
cat techops.csr|base64 | tr -d "\n"
```

✅ Step 3: Approve your request 
```
kubectl certificate approve <certificate-signing-request-name>
```

✅ Step 4: Get your certificate by running below command
```
kubectl get csr techops -o jsonpath='{.status.certificate}' > certificate.crt

cat certificate.crt
```

✅ Step 5: Create below menifest for role base authentication

```

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: role
rules:
  - verbs:
      - list
    apiGroups:
      - ''
    resources:
      - namespaces
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: techops
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: role
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: mon
  namespace: monitoring
rules:
  - verbs: ["get","watch","list"]
    apiGroups: [""]
    resources: ["pods","pods/log","pods/exec","events"]
  - verbs: ["get","watch","list"]
    apiGroups: ["apps"]
    resources: ["deployments"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: role-binding
  namespace: monitoring
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: techops
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: mon

```



