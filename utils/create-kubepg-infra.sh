#!/bin/sh

set -eu

export LIBVIRT_DEFAULT_URI=qemu:///system

# Generate an SSH key pair for the post install deployment
mkdir -p ~/.kubepg/
ssh-keygen -o -a 100 -t ed25519 -f ~/.kubepg/kubepg_id -P ""
public_key=$(cat ~/.kubepg//kubepg_id.pub)
kubepg_net=$(virsh net-dumpxml kubepg | grep -oP "ip address='\K\d+\.\d+.\d+")

# Create the vms
for i in $(seq 1 6)
do
    sed "s~%NEW_SSH_KEY%~${public_key}~g" etc/centos7-minimal.ks.cfg > tmp/centos7-minimal.ks.cfg.tmp
    sed -i "s~%GW%~${kubepg_net}.1~g" tmp/centos7-minimal.ks.cfg.tmp
    sed -i "s~%IP%~${kubepg_net}.1${i}~g" tmp/centos7-minimal.ks.cfg.tmp
    sed -i "s~%HOSTNAME%~kubepg-node${i}~g" tmp/centos7-minimal.ks.cfg.tmp
    utils/create-kubepg-vm.sh -n kubepg-node${i} \
        -i tmp/CentOS-7-x86_64-Minimal-1810.iso \
        -k tmp/centos7-minimal.ks.cfg.tmp \
        -r 2048 \
        -c 2 \
        -s 20 \
        -b kubepg-br \
        -d
done

utils/deploy-ssh-config.sh

echo You can now login into the node1 VM using:
echo
echo "   ssh kpg-node1"
echo
echo or deploy the Kubernetes cluster using:
echo
echo "  kubespray/deploy.sh"
echo 
