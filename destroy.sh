virsh --connect=qemu:///system destroy node1
virsh --connect=qemu:///system destroy node2
virsh --connect=qemu:///system undefine node1
virsh --connect=qemu:///system undefine node2

