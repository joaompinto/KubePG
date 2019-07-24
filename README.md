# Kubernetes Play Ground Setup 

This repository provides scripts that can be used to setup a kubernetes playground using libvirt.

Planned:

- [x] Install CentOS 7 nodes using virt-install
    - [x] server .iso image
    - [x] minimal kickstart
- [ ] Install Upstream Kubernetes using kubespray

Tested on Fedora 30, should work with any modern Linux distribution.

## Requirements

- Libvirt/KVM setup per your Linux distribution instructions
- virt-install


## Install

```sh

# Download the Centos ISO
./download.sh

# Run the CentOS nodes ISO install (with kickstart)
# The "Performing post-installation setup tasks" may take several minutes
./create-all-vms.sh.sh

```


## Uninstall

You can destroy the related nodes using:
```sh
./destroy.sh
```

## References:

- https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/

- https://earlruby.org/2018/12/setting-up-a-personal-production-quality-kubernetes-cluster-with-kubespray/

