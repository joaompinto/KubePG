#/bin/sh

node_list=$*


function install_python36() {
    # Install Python3 )required for kubespray)
    yum install -y centos-release-scl
    yum install -y rh-python36 rh-python36-python-pip
}

function download_kubespray() {
    curl -L https://github.com/kubernetes-sigs/kubespray/archive/v2.10.4.tar.gz -o kubespray.tar.gz
    tar xf kubespray.tar.gz
}

function create_ansible_inventory() {
    cd kubespray-2*
    # Create the ansible inventory
    scl enable rh-python36 bash << _EOF_
pip install -r requirements.txt
rm -Rf inventory/mycluster/
cp -rfp inventory/sample inventory/mycluster
CONFIG_FILE=inventory/mycluster/hosts.yaml \
    python contrib/inventory_builder/inventory.py ${node_list}
_EOF_

    cat  > inventory/mycluster/hosts.ini << _EOF_
[all:vars]
kubectl_localhost=true
_EOF_
}

function run_kubernetes_install_playbook() {

    # Run the kubernetes install playbook
    scl enable rh-python36 bash << _EOF_
export ANSIBLE_REMOTE_USER=root
ansible-playbook -i inventory/mycluster/hosts.yaml \
    --key-file ~/kubepgs_id \
    cluster.yml \
    -vvv
_EOF_
}

function setup_every_node_fw_rules() {
    # This runs on every node
    for node in ${node_list}
    do
        echo $node
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --add-port=10250/tcp  --permanent       # kubelet access (for logs)
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --add-port=443/tcp --permanent          # Required for the dasboard 
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --add-port={2379,2380}/tcp --permanent  # etcd
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --add-port=6443/tcp --permanent         # kube api-server
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --add-port=179/tcp --permanent          # callico (BGP)
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --add-port=8080/tcp  --permanent        # default http service port
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --add-port=80/tcp  --permanent          # ingress service
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepgs_id root@$node firewall-cmd --reload
    done
}

function setup_etc_hosts() {
    sed -i '/ kubepgs.local$/d' /etc/hosts
    echo "$(ip route get 1 | awk '{print $NF;exit}') kubepgs.local" >> /etc/hosts
}

setup_every_node_fw_rules
install_python36
download_kubespray
create_ansible_inventory
run_kubernetes_install_playbook
setup_etc_hosts
