## K8s Cluster on Ubuntu 22.4 with HA (Multi master)

Kubernetes Cluster Installations - On Premises




Setup guide for Kubernetes 1.32 on Ubuntu 22.04 with 3 master- nodes and 5 worker- nodes using kubeadm. Visit below link to know more about EOL of k8s release.
https://kubernetes.io/releases/patch-releases/#support-period

Prerequisites & Guidelines
* 8 Ubuntu 22.04 servers (3 master-s, 5 worker-s).
* Minimum 4 CPU cores and 8 GB RAM per node.
* Minimum 500 GB to 1 TB Space per node.
* User with sudo privileges. (Do not use root user)
* Stable internet connection.
* Hostname resolution across nodes (either via DNS or /etc/hosts).
* Firewall and swap disabled.
* POD Network/Subnet like:- 192.168.0.0/16
* CIS Compliant Partitions to avoid after security-audit redeployments.
* Updated OS (apt update && apt upgrade)
* NTP synced or Correct Time Zone and Date & Time (chronyd)
* CIS Hardened and Security Fixed (OS).
* Syslog Server or SIEM integrated along with logrote configured.
* Antivirus Installed.
* Centralized NIS/LDAP configured. (Optional)

CIS-Compliant Mandatories Partitioning Scheme for Kubernetes Nodes
```
Partition  | master- Node (Control Plane) | worker- Node | Mount Options
/      (root)        50GB                   100GB      defaults
/boot                2GB                    2GB        defaults,nodev
/usr                 20GB                   20GB       defaults,nodev
/var                 10GB                   10GB       defaults,nodev
/var/tmp             10GB                   10GB       defaults,nodev,nosuid,noexec
/tmp                 10GB                   10GB       defaults,nodev,nosuid,noexec
/var/log             20GB                   50GB       defaults,nodev,nosuid,noexec
/var/log/audit       10GB                   10GB       defaults,nodev,nosuid,noexec
/var/lib/containerd  100GB                  200GB      defaults,nodev,nosuid,noexec
/var/lib/kubelet     50GB                   100GB      defaults,nodev,nosuid,noexec
/var/lib/etcd        40GB (master-s only)   N/A        defaults,nodev,nosuid,noexec
/home                20GB                   20GB       defaults,nodev,nosuid
/data (Optional)     200GB (For PVs)        500GB+     defaults  (For local PVs) 
swap                 0GB (Disabled)         0GB(Disabled)  swapoff
```



Step 1: Set Up Hostnames
Assign hostnames to each node:
# On master- Nodes
sudo hostnamectl set-hostname master-1
sudo hostnamectl set-hostname master-2
sudo hostnamectl set-hostname master-3

# On worker- Nodes
sudo hostnamectl set-hostname worker-1
sudo hostnamectl set-hostname worker-2
sudo hostnamectl set-hostname worker-3
sudo hostnamectl set-hostname worker-4
sudo hostnamectl set-hostname worker-5


Step 2: Disable Swap & Firewall along with loading Kernel Modules
```
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```
```
sudo modprobe overlay
sudo modprobe br_netfilter
```

```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```

```
sudo systemctl stop ufw && sudo systemctl disable ufw
```


Step 3: Configure Sysctl Settings
```
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

```
sudo sysctl --system
```


Step 4: Install Container Runtime (Containerd)

```
sudo apt update
sudo apt install -y containerd

# Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Modify config to use systemd cgroup driver
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
```

Step 5: Install crictl 

```
export CRICTL_VERSION="1.32.0"

wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRICTL_VERSION}/crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz

sudo tar -C /usr/local/bin -xzf crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz

sudo crictl --version
```

Step 6: Configure crictl with crictl 

```
sudo echo "runtime-endpoint: unix:///run/containerd/containerd.sock" | sudo tee /etc/crictl.yaml

# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

crictl info
```


Step 5: Install Kubernetes Components (Version 1.32)

```
sudo apt update

sudo apt install -y apt-transport-https ca-certificates curl gpg

sudo rm -f /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg

sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg

sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

sudo chmod 644 /etc/apt/keyrings/kubernetes-archive-keyring.gpg

sudo gpg --list-keys --keyring /etc/apt/keyrings/kubernetes-archive-keyring.gpg

sudo echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update

sudo apt install -y kubelet kubeadm kubectl

sudo systemctl daemon-reload
sudo systemctl enable kubelet --now
sudo systemctl status kubelet

sudo apt-mark hold kubelet kubeadm kubectl
```


Step 6: Initialize the Kubernetes Cluster (Only on master-1)

```
Run the following command on master-1:
sudo kubeadm init --control-plane-endpoint master-1 --upload-certs --pod-network-cidr=192.168.0.0/16

or

If you are using HAPROXY for K8S Master


sudo kubeadm init --control-plane-endpoint "<HAPROXY_VIP>:6443" --upload-certs --pod-network-cidr=192.168.0.0/16
Save the kubeadm join command output for master-2, master-3, and worker- nodes.
```


Step 7: Configure kubectl (Only on master-1)

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


Step 8: Set Up Networking (Calico)

```
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```


Step 9: Join Other master-s (On master-2 & master-3)

```
Run on master-2 and master-3:
To get joining coommand

sudo kubeadm token create --print-join-command --certificate-key $(kubeadm init phase upload-certs --upload-certs | tail -1)

sudo kubeadm join master-1:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH> --control-plane --certificate-key <CERTIFICATE-KEY>

or

If you are using HAPROXY for K8S Master

sudo kubeadm join "<HAPROXY_VIP>:6443" --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH> --control-plane --certificate-key <CERTIFICATE-KEY>
```


Step 10: Join worker- Nodes

```
Run on each worker- node (worker-1 - worker-5):
To get joining coommand

sudo kubeadm token create --print-join-command

sudo kubeadm join master-1:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>

or

If you are using HAPROXY for K8S Master

sudo kubeadm join "<HAPROXY_VIP>:6443" --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

Step 11: Verify Cluster

  1. On master-1, check the nodes:
  2. kubectl get nodes
  3. This should list all 8 nodes as Ready. Now deploy a sample/test service like nginx and browse it using curl or browser.

