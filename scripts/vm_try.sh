#!/bin/bash

# VM Launch Script for QEMU

VM_IMAGE="arch_vm.qcow2"

if [ ! -f "$VM_IMAGE" ]; then
    echo "Error: $VM_IMAGE not found."
    exit 1
fi

echo ":: Launching Arch Linux VM..."
qemu-system-x86_64 \
    -m 4G \
    -enable-kvm \
    -cpu host \
    -smp 2 \
    -drive file="$VM_IMAGE",format=qcow2 \
    -net nic \
    -net user,hostfwd=tcp::2222-:22 \
    -vga virtio \
    -display gtk,gl=on
