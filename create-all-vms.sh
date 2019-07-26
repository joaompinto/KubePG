#!/bin/sh

set -eu

# Create a worker node
sudo ./create-vm -n node2 \
    -i CentOS-7-x86_64-Minimal-1810.iso \
    -k centos7-minimal.ks.cfg \
    -r 2048 \
    -c 2 \
    -s 10 \
    -d

# Create the master node
sudo ./create-vm -n node1 \
    -i CentOS-7-x86_64-Minimal-1810.iso \
    -k centos7-minimal.ks.cfg \
    -r 2048 \
    -c 2 \
    -s 10 \
    -d

echo Waiting for the VM IP to be available...
VM_IP_NODE2=$(./get-vm-ip node2)
VM_IP=$(./get-vm-ip node1)
[[ -z "$VM_IP" ]] && echo Timed out waiting for IP to be available && exit 1

echo You can now login into the VM using:
echo
echo    ssh -i keys/kubepgs_id_ed25519 root@$VM_IP
echo
echo or deply the Kubernetes cluster using:
echo
echo    ./kubespray-deploy.sh $(./get-vm-ip node1) $(./get-vm-ip node2)
echo 
