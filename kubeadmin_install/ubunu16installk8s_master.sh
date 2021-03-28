#!/bin/bash
# Ubuntu 16.04 LTS install k8s
# OS hostname need all lower case


############################################################################
# Check root privilege: Make sure only root can run our script
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

LOGFILE=$HOME/logs/ubuntu16installk8s_master.log
touch $LOGFILE

sed -i "s,tw.,,g" /etc/apt/sources.list >> $LOGFILE

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system


# apt-get install & upgrade
echo "========================================================================================"  >> $LOGFILE 
echo "apt-get install & upgrade" >> $LOGFILE
apt-get update >> $LOGFILE
apt-get install -y apt-transport-https ca-certificates curl >> $LOGFILE
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg >> $LOGFILE
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update  >> $LOGFILE
sudo apt-get install -y kubelet kubeadm kubectl docker.io >> $LOGFILE
sudo apt-mark hold kubelet kubeadm kubectl >> $LOGFILE


# Create /etc/cni/net.d/10-weave.conf setting 
#echo "========================================================================================"  >> $LOGFILE 
#echo "add /etc/cni/net.d/10-weave.conf" >> $LOGFILE
#mkdir /etc/cni  >> $LOGFILE 
#mkdir /etc/cni/net.d  >> $LOGFILE 
#cat <<EOF >/etc/cni/net.d/10-weave.conf  
# {
#    "name": "weave",
#    "type": "weave-net"
# }
#EOF

#sudo swapoff -a

# kubernetes initialization
#echo "========================================================================================"  >> $LOGFILE 
#echo "kubernetes initialization" >> $LOGFILE 
#kubeadm init  >> $LOGFILE

#echo "========================================================================================"  >> $LOGFILE 
#echo "export KUBECONFIG" >> $LOGFILE 
#mkdir -p $HOME/.kube  >> $LOGFILE 
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config  >> $LOGFILE 
#sudo chown $(id -u):$(id -g) $HOME/.kube/config  >> $LOGFILE 
#export KUBECONFIG=$HOME/admin.conf

#echo "========================================================================================"  >> $LOGFILE 
#echo "kubectl get nodes" >> $LOGFILE 
#kubectl get nodes  >> $LOGFILE 

#echo "========================================================================================"  >> $LOGFILE 
#echo "Create kubernetes cluster network" >> $LOGFILE 
#curl -L https://git.io/weave-kube -o /opt/weave-kube
#kubectl apply -f /opt/weave-kube

#echo "========================================================================================"  >> $LOGFILE 
#echo "Install kubernetes dashboard" >> $LOGFILE 
#kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml


