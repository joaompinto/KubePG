# Adapted from 
# https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/


# Create a worker node
sudo ./create-vm -n node2 \
    -i CentOS-7-x86_64-Minimal-1810.iso \
    -k centos7-minimal.ks.cfg \
    -r 1024 \
    -c 1 \
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
echo    ./kubespray-deploy.sh $VM_IP $VM_IP_NODE2
echo 
#sudo virt-install \
#--virt-type=kvm \
#--name centos7 \
#--ram 2048 \
#--vcpus=1 \
#--os-variant=centos7.0 \
#--cdrom=/var/lib/libvirt/boot/CentOS-7-x86_64-Minimal-1810.iso \
#--network=bridge=br0,model=virtio \
#--graphics vnc \
#--disk path=/var/lib/libvirt/images/centos7.qcow2,size=40,bus=virtio,format=qcow2
