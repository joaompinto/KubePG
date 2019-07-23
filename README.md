# Kubernetes Play Ground Setup 

This repository provides scripts that can be used to setup a kubernetes playground using libvirt.

Planned:

- [x] Install CentOS 7 nodes «using virt-install»
- [ ] Install Upstream Kubernetes using kubespray

Tested on Fedora 30, should work with any modern Linux distribution.

## Requirements

- Libvirt/KVM setup per your Linux distribution instructions
- virt-install

You must setup/enable libvirt per your Linux distribution instructions

## Installl

```sh

# Download the Centos ISO
./download.sh

# Run the CentOS nodes ISO install (with kickstart)
# The "Performing post-installation setup tasks" may take several minutes
./create-all-vms.sh.sh


# Login into the master node
ssh root@$(./get-vm-ip node1)
# Password is: password
```

## References:

https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/
