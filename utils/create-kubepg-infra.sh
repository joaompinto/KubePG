#!/bin/sh

set -eu

LIBVIRT_DEFAULT_URI=qemu:///system

# Generate an SSH key pair for the post install deployment
mkdir -p keys/
ssh-keygen -o -a 100 -t ed25519 -f keys/kubepg_id -P ""
public_key=$(cat keys/kubepg_id.pub)

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


#sudo sed -i '/ kubepg.local$/d' /etc/hosts
#echo "$VM_IP kubepg.local" |sudo tee -a /etc/hosts

echo You can now login into the node1 VM using:
echo
echo "   ssh -i keys/kubepg_id root@${kubepg_net}.11"
echo
echo or deploy the Kubernetes cluster using:
echo
echo "  kubespray/deploy.sh"
echo 
