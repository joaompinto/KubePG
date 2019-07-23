# Adapted from 
# https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/

sudo ./create-vm -n node1 \
    -i CentOS-7-x86_64-Minimal-1810.iso \
    -k centos7-minimal.ks.cfg \
    -r 1024 \
    -c 1 \
    -s 10 \
    -d
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
