#!/bin/sh
set -eu

LIBVIRT_DEFAULT_URI=qemu:///system
kubepg_net=$(virsh net-dumpxml kubepg | grep -oP "ip address='\K\d+\.\d+.\d+")


mkdir -p ~/.kube
script_dir=$(dirname $0)
TARGET=${kubepg_net}.11

node_list=""
for i in $(seq 1 6)
do
    new_node=${kubepg_net}.1${i}
    node_list="${node_list} ${new_node}"
done

KEY="-i keys/kubepg_id"
scp $KEY ${script_dir}/install.sh root@$TARGET:kubespray-install.sh
scp $KEY keys/kubepg_id root@$TARGET:
ssh $KEY root@$TARGET -- bash kubespray-install.sh ${node_list}
scp $KEY root@$TARGET:~/.kube/config ~/.kube/kubepg-admin.conf
export KUBECONFIG=~/.kube/kubepg-admin.conf

echo "A kubeconfig file for the cluster is available at: ~/.kube/kubepg-admin.conf"
echo
echo You can setup kubectl to use your cluster using:
echo
echo "   export KUBECONFIG=~/.kube/kubepg-admin.conf"
echo
kubectl cluster-info
