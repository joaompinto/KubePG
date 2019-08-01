#/bin/sh

for i in $(seq 1 6)
do
    virsh --connect=qemu:///system destroy node${i}
    virsh --connect=qemu:///system undefine node${i}
done

rm -f keys/*