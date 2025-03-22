#!/bin/bash

echo -e "##################################################### CHECKING STATUS OF FIREWALL AND STOPPING ######################################################\n"

if systemctl is-active --quiet firewalld; then
    echo -e "turning off firewall"
    systemctl status firewalld;
    if ! systemctl stop firewalld; then
        echo "Failed to stop the firewall!"
        exit 1
    fi

    systemctl status firewalld;
else
    echo "firewall is not running"

    systemctl status firewalld;
    sleep 2;
fi

echo -e "\n################################################################ DISABLING SWAP  #################################################################\n"

swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sleep 1;

echo -e "\n############################################# Forwarding IPv4 and letting iptables see bridged traffic ############################################\n"

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sleep 1;

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sleep 1;
sudo sysctl --system
sleep 2;


lsmod | grep br_netfilter
lsmod | grep overlay

sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

sleep 3;

while true; do 
    read -p "Do you want to continue to install containerd? (yes/no): " INPUT
    case $INPUT in 
        [yY]* )
            echo -e "######################################################## INSTALLING CONTAINERD ##############################################################"
            curl -LO https://github.com/containerd/containerd/releases/download/v2.0.0/containerd-2.0.0-linux-amd64.tar.gz
            sleep 6;
            sudo tar Cxzvf /usr/local containerd-2.0.0-linux-amd64.tar.gz
            sleep 2; 
            curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service;
            sleep 1;
            sudo mkdir -p /usr/local/lib/systemd/system/
            sudo mv containerd.service /usr/local/lib/systemd/system/
            sudo mkdir -p /etc/containerd
            export PATH="$PATH:/usr/local/bin"
            containerd config default | sudo tee /etc/containerd/config.toml
            sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
            sudo systemctl daemon-reload
            sudo systemctl enable --now containerd
            sleep 1;
            if systemctl is-active --quiet containerd; then
                # sudo systemctl status containerd
                sleep 1;
                echo -e "\n############################################## CONTAINERD INSTALLED SUCCUSSFULLY!!!! #################################################\n" 
            else
                echo "ooppps.... something went wrong please check and verify."
                echo -e "\n###########*********************************************** EXITING *******************************************************###########"
                exit 1;
            fi 

            while true; do 
                read -p "Do you want to continue to install runc? (yes/no): " INPUTFORRUNC
                case $INPUTFORRUNC in 
                    [yY]* )
                        echo -e "\n####################################################### INSTALLING RUNC #######################################################\n"
                        curl -LO https://github.com/opencontainers/runc/releases/download/v1.2.4/runc.amd64
                        sleep 3;
                        sudo install -m 755 runc.amd64 /usr/local/sbin/runc
                        echo 'export PATH="$PATH:/usr/local/sbin"' >> ~/.bashrc
                        echo -e "\n################################################## RUNC INSTALLED SUCCUSSFULLY ################################################\n"

                        while true; do 
                            read -p "Do you want to continue to install Kubelet, kubeadm? (yes/no): " INPUTFORKUBE
                            case $INPUTFORKUBE in
                                [yY]* )
                                    echo -e "\n############################################# INSTALLING KUBEADM KUBELET AND KUBECTL #########################################\n"
                                    sudo setenforce 0
                                    sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
                                    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
                                    sleep 1; 
                                    sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
                                    sudo systemctl enable --now kubelet
                                    sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock
                                    echo -e "\n############################################ YOUR KUBERNETES WORKER NODE IS READY #############################################"
                                    echo -e "\n##################################################### AUTHER MOHAMMAD YUSUF ###################################################"
                                    echo -e "\n###########********************************************** THANK YOU!!!! ********************************************###########\n"
                                    break
                                    ;;
                                [nY]* )
                                    echo -e "\n###########********************************* EXITING ********************************************###########"
                                    exit 0
                                    ;;
                                * )
                                    echo -e "\noops please provide a valid input. Y for yes and N for no."
                                    ;;
                            esac
                        done
                        break
                        ;;
                    [nY]* )
                        echo -e "\n###########********************************* EXITING *******************************************###########"
                        exit 0
                        ;;
                    * )
                        echo "oops please provide a valid input. Y for yes and N for no."
                        ;;
                esac
            done

            break
            ;;
        [nY]* )
            echo "OK Thank you!! You are exiting bye bye..."
            exit 0
            ;;
        * )
            echo "oops please provide a valid input. Y for yes and N for no."
            ;;
    esac
done

#This are for making control plane node run three line before  init kubeadm command. optinal.
#curl -LO https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-amd64-v1.6.2.tgz
#sudo mkdir -p /opt/cni/bin
# sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.6.2.tgz

# run below command after init kubeadm. mandatory 
# curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml -O
# kubectl apply -f calico.yaml

