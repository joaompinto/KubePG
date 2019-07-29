# Kubernetes Play Ground Setup 

This repository provides scripts that can be used to setup a kubernetes playground using libvirt.

## Motivation

If you are searching for the easiest/quickest option to get a local hosted Kubernetes cluster for experimentation, the best options are [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/), [minishift](https://docs.okd.io/latest/minishift/getting-started/installing.html) or [k3s](https://k3s.io/). 

Mini*/k3s are great for testing, they are packaged/installed using custom methods which were optimized for an easy/quick experience but which are very different from the methods that you would use to install a production kubernetes cluster.

There are several vagrant-based projects that work nice for production-alike environment, but they mostly rely on VirtualBox and/or Vagrant specific features that you will not use in a production deployment.

KubePGS leverages he same libvirt/kvm that you are likely to find on opensource based virtualizaion providers, and uses [kubespray](https://github.com/kubernetes-sigs/kubespray) which you might also be using for production deployments.


## Requirements

- Libvirt/KVM setup per your Linux distribution instructions
- virt-install

Tested on Fedora 30, should work with any modern Linux distribution.

## Install

```sh

# Download the CentOS ISO
utils/download-iso.sh

# Run the CentOS nodes ISO install (with kickstart)
# "Performing post-installation setup tasks" may take several minutes
utils/create-kpgs-vm.sh
```

## Uninstall

You can destroy the related nodes using:
```sh
utils/destroy-kpgs-vm.sh
```

## References:

- https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/

- https://earlruby.org/2018/12/setting-up-a-personal-production-quality-kubernetes-cluster-with-kubespray/

