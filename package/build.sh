#!/bin/bash

virsh destroy anaconda-bootc-test
virsh undefine --storage vda,vdb,vdc,vdd,vde,vdf,vdg,vdh anaconda-bootc-test

set -xeuo pipefail

IMAGE=$1
SSHKEY=$2

# These are used in the kickstart %pre
mkdir -p /var/srv
echo $IMAGE > /var/srv/image
cp $SSHKEY /var/srv/sshkey

# Copy the image into /var/srv/oci to be used in the kickstart
skopeo copy "containers-storage:$IMAGE" "oci:/var/srv/oci:$IMAGE"

# Create a new VM with 8 disks
# 1 for /root, 3 for /data, 4 for /logs
virt-install \
   --name anaconda-bootc-test \
   --vcpus 4 \
   --ram 8192 \
   --disk size=40 \
   --disk size=1 \
   --disk size=1 \
   --disk size=1 \
   --disk size=1 \
   --disk size=1 \
   --disk size=1 \
   --disk size=1 \
   --location /var/lib/libvirt/images/boot.iso \
   --os-variant rhel9.5 \
   --initrd-inject=./inst.ks \
   --memorybacking=source.type=memfd,access.mode=shared \
   --filesystem=/var/srv/,host-var-srv,driver.type=virtiofs \
    --graphics none \
    --console pty,target_type=serial \
    --extra-args "console=ttyS0,115200n8 serial inst.ks=file:/inst.ks"

virsh domifaddr anaconda-bootc-test --full
