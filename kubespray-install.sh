#/bin/bash

export nodes="$*"

# Setup the firewalls to allow connection to the etcd
firewall-cmd --add-port={2379,2380}/tcp --permanent # etcd
firewall-cmd --add-port=443/tcp  --permanent    # Reqiored for the dasboard 
firewall-cmd --add-port=6443/tcp  --permanent   # kube api-server
firewall-cmd --reload


# Install Python3 required for kubespray
yum install -y centos-release-scl
yum install -y rh-python36 rh-python36-python-pip

curl -L  https://github.com/kubernetes-sigs/kubespray/archive/v2.10.4.tar.gz -o kubespray.tar.gz
tar xzvf kubespray.tar.gz
cd kubespray-2*

# Create the ansible inventory
scl enable rh-python36 bash << _EOF_
pip install -r requirements.txt
rm -Rf inventory/mycluster/
cp -rfp inventory/sample inventory/mycluster
mv inventory/mycluster/hosts.ini inventory/mycluster/hosts.yaml
CONFIG_FILE=inventory/mycluster/hosts.yaml \
    python contrib/inventory_builder/inventory.py $nodes
_EOF_
cat  >> inventory/mycluster/hosts.ini  << _EOF_
[all:vars]
kubectl_localhost=true
_EOF_

# Run the kubernetes install playbook
scl enable rh-python36 bash << _EOF_
export ANSIBLE_REMOTE_USER=root
ansible-playbook -i inventory/mycluster/hosts.yaml \
    --key-file ~/kubepgs_id_ed25519 \
    cluster.yml \
    -vvv
_EOF_
