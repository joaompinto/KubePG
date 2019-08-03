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
    --key-file ~/kubepg_id \
    cluster.yml \
    -vvv
_EOF_
}

function setup_every_node_fw_rules() {
    read -r -d '' RULES << EOM
        --add-port=10250/tcp            # kubelet access «for logs»
        --add-port=443/tcp              # Required for the dasboard
        --add-port={2379,2380}/tcp      # etcd
        --add-port=6443/tcp             # kube api-server
        --add-port=179/tcp              # callico (BGP)
        --add-port=8080/tcp             # default http service port
        --add-port=80/tcp               # ingress service
EOM

    # Create the rules string
    rules=""
    while IFS= read -r line
    do 
        rules="$rules $(echo $line|egrep -o '^[^#]*')"
    done <<< "$RULES"

    # This runs on every node
    for node in ${node_list}
    do
        FIREWALL_CMD="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/kubepg_id root@$node firewall-cmd"
        $FIREWALL_CMD $rules --permanent
        ${FIREWALL_CMD} --reload
    done
}

setup_every_node_fw_rules
install_python36
download_kubespray
create_ansible_inventory
run_kubernetes_install_playbook
