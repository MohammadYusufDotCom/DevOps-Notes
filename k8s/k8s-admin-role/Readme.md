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
