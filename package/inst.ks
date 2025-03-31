%pre --erroronfail
mkdir -p /mnt/host-var-srv
mount -t virtiofs -o ro host-var-srv /mnt/host-var-srv

SSHKEY=$(cat /mnt/host-var-srv/sshkey)
IMAGE=$(cat /mnt/host-var-srv/image)

echo "sshkey --username root '$SSHKEY'" > /tmp/sshkey.ks
echo "ostreecontainer --transport oci --url /mnt/host-var-srv/oci:$IMAGE" > /tmp/ostree.ks
%end

# Basic setup
text --non-interactive
network --bootproto=dhcp --device=link --activate

# Basic partitioning
clearpart --all --initlabel --disklabel=gpt
reqpart --add-boot
part / --grow --fstype xfs --ondisk=vda

# Define the drives
part raid.01 --size=5000 --ondisk=vdb
part raid.02 --size=5000 --ondisk=vdc
part raid.03 --size=5000 --ondisk=vdd
part raid.04 --size=5000 --ondisk=vde
part raid.05 --size=5000 --ondisk=vdf
part raid.06 --size=5000 --ondisk=vdg
part raid.07 --size=5000 --ondisk=vdh

# Define the RAID device
raid pv.01 --level=5 --device=pv.01 --fstype=xfs raid.01 raid.02 raid.03
raid pv.02 --level=10 --device=pv.02 --fstype=xfs raid.04 raid.05 raid.06 raid.07

# create mssql user and group
group --name=mssql --gid=1000
user --name=mssql --uid=1000

# Create logical volumes
volgroup datavg pv.01
volgroup logsvg pv.02
logvol /var/mssql/data --vgname=datavg --percent=100 --name=datavol --fstype=xfs
logvol /var/mssql/logs --vgname=logsvg --percent=100 --name=logsvol --fstype=xfs

# Install the bootc image
%include /tmp/ostree.ks

firewall --disabled
services --enabled=sshd

# Only inject a SSH key for root
rootpw --iscrypted locked
%include /tmp/sshkey.ks
reboot

# Ensure we fetch updates from the main regsitry
%post
bootc switch --mutate-in-place --transport registry quay.io/ckyrouac/bootc-mssql-example

# These filesystem modifications need to happen here instead of in the bootc Containerfile
# because we need the mounts to be setup
chown -R mssql:mssql /var/mssql/data
chown -R mssql:mssql /var/mssql/logs
%end
