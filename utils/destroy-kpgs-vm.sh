#/bin/sh

for i in $(seq 1 6)
do
    virsh --connect=qemu:///system destroy kubepg-node${i}
    virsh --connect=qemu:///system undefine kubepg-node${i}
done

rm -f ~/.kubepg/kubepg_id*

