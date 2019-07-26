#!/bin/sh

set -eu

# Generate an SSH key pair for the post install deployment
mkdir -p keys/
#rm -rf keys/*
ssh-keygen -o -a 100 -t ed25519 -f keys/kubepgs_id -P ""
public_key=$(cat keys/kubepgs_id.pub)
sed "s~%NEW_SSH_KEY%~${public_key}~g" centos7-minimal.ks.cfg > centos7-minimal.ks.cfg.tmp

# Create the master/worker node
sudo ./create-vm -n node1 \
    -i CentOS-7-x86_64-Minimal-1810.iso \
    -k centos7-minimal.ks.cfg.tmp \
    -r 2048 \
    -c 2 \
    -s 10 \
    -d

echo Waiting for the VM IPs to be available...
VM_IP=$(./get-vm-ip node1)
[[ -z "$VM_IP" ]] && echo Timed out waiting for IP to be available && exit 1

echo You can now login into the VM using:
echo
echo    ssh -i keys/kubepgs_id.pub root@$VM_IP
echo
echo or deply the Kubernetes cluster using:
echo
echo    ./kubespray-deploy.sh $(./get-vm-ip node1) $(./get-vm-ip node2)
echo 
