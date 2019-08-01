#!/bin/sh

set -eu

# Generate an SSH key pair for the post install deployment
mkdir -p keys/
#rm -rf keys/*
ssh-keygen -o -a 100 -t ed25519 -f keys/kubepgs_id -P ""
public_key=$(cat keys/kubepgs_id.pub)
sed "s~%NEW_SSH_KEY%~${public_key}~g" etc/centos7-minimal.ks.cfg > tmp/centos7-minimal.ks.cfg.tmp

# Create the master/worker node
for i in $(seq 1 6)
do
    sudo utils/create-vm -n node${i} \
        -i tmp/CentOS-7-x86_64-Minimal-1810.iso \
        -k tmp/centos7-minimal.ks.cfg.tmp \
        -r 2048 \
        -c 2 \
        -s 20 \
        -d
done

echo Waiting for the VM IPs to be available...
VM_IP=$(utils/get-vm-ip node1)

[[ -z "$VM_IP" ]] && echo Timed out waiting for IP to be available && exit 1

sudo sed -i '/ kubepgs.local$/d' /etc/hosts
echo "$VM_IP kubepgs.local" |sudo tee -a /etc/hosts

echo You can now login into the VM using:
echo
echo "   ssh -i keys/kubepgs_id root@kubepgs.local"
echo
echo or deply the Kubernetes cluster using:
echo
echo "  kubespray/deploy.sh kubepgs.local"
echo 
