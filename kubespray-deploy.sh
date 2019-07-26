#!/bin/sh
set -eu
mkdir -p ~/.kube

TARGET=$1
KEY="-i keys/kubepgs_id_ed25519"
scp $KEY kubespray-install.sh root@$TARGET:
scp $KEY keys/kubepgs_id_ed25519 root@$TARGET:
ssh $KEY root@$TARGET -- bash ./kubespray-install.sh $*
scp $KEY root@$TARGET:~/.kube/config ~/.kube/kubepgs_config
export KUBECONFIG=~/.kube/kubepgs_config
echo
echo A kubeconfig file for the cluster is available at: ~/.kube/kubepgs_config
echo
echo To use it kubectl just run: 
echo "   export KUBECONFIG=~/.kube/kubepgs_config"
echo
kubectl cluster-info
