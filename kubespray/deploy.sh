#!/bin/sh
set -eu
mkdir -p ~/.kube
script_dir=$(dirname $0)
TARGET=$1

node_list=""
for i in $(seq 1 6)
do
    new_node=$(utils/get-vm-ip node${i})
    node_list="${node_list} ${new_node}"
done

KEY="-i keys/kubepgs_id"
scp $KEY ${script_dir}/install.sh root@$TARGET:kubespray-install.sh
scp $KEY keys/kubepgs_id root@$TARGET:
ssh $KEY root@$TARGET -- bash kubespray-install.sh ${node_list}
scp $KEY root@$TARGET:~/.kube/config ~/.kube/kubepgs-admin.conf
export KUBECONFIG=~/.kube/kubepgs-admin.conf

echo A kubeconfig file for the cluster is available at: ~/.kube/kubepgs-admin.conf
echo
echo You can setup kubectl to use your cluster using:
echo
echo "   export KUBECONFIG=~/.kube/kubepgs-admin.conf"
echo
kubectl cluster-info
