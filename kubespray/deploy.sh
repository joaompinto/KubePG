#!/bin/sh
set -eu
mkdir -p ~/.kube
script_dir=$(dirname $0)

TARGET=$1
KEY="-i keys/kubepgs_id"
scp $KEY ${script_dir}/install.sh root@$TARGET:kubespray-install.sh
scp $KEY keys/kubepgs_id root@$TARGET:
ssh $KEY root@$TARGET -- bash kubespray-install.sh $*
scp $KEY root@$TARGET:~/.kube/config ~/.kube/kubepgs_config
export KUBECONFIG=~/.kube/kubepgs_config
echo
echo A kubeconfig file for the cluster is available at: ~/.kube/kubepgs_config
echo
echo You can setup kubectl to use your cluster using:
echo
echo "   export KUBECONFIG=~/.kube/kubepgs_config"
echo
kubectl cluster-info
