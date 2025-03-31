# rhel-mssql-bootc

To run this example:

1. Deploy a RHEL9 system, install the dependencies, start libvirt. An easy way is to use the AWS EC2 console to deploy a free tier RHEL9 image. Make sure to use at least 30GB of disk space and 2GB of memory. Make sure the system is registered.
   ```
   sudo su
   dnf -y groupinstall "Virtualization Host"
   dnf -y install git podman skopeo virt-install
   subscription-manager register
   systemctl enable virtqemud.socket
   systemctl start virtqemud.socket
   systemctl enable libvirtd
   systemctl start libvirtd
   ```
1. Clone this repo onto the system
   ```sh
   git clone https://github.com/ckyrouac/bootc-mssql-examples.git
   cd bootc-mssql-examples/package
   ```
1. Download the AdventureWorks sample data
   ```sh
   curl -o ./AdventureWorks2022.bak -L https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak
   ```
1. Download the RHEL boot iso
   ```sh
   curl "<url>" -o "/var/lib/libvirt/images/boot.iso"
   ```
1. Build the bootc image. Tag it with a repo of your chosing.
   ```sh
   podman login registry.redhat.io
   podman build . -t quay.io/<user>/bootc-mssql-example
   ```
1. Push the bootc image to a remote repo.
   ```sh
   podman login quay.io
   podman push quay.io/<user>/bootc-mssql-example
   ```
1. Create an ssh key pair if you don't already have one.
   ```sh
   ssh-keygen
   ```
1. Run the build.sh script to create a new VM and install the bootc image via `inst.ks`.
   ```sh
   ./build.sh "quay.io/<user>/bootc-mssql-example" /root/.ssh/id_rsa.pub
   ```
1. SSH into the image. The `build.sh` script outputs the new VM's IP.
   ```sh
   ssh -i <keyfile> root@<ip>
   ```
1. Verify the mssql service started succesfully.
   ```sh
   systemctl status mssql-server.service
   ```
1. Run the included demo script to validate mssql is behaving correctly.
   ```sh
   /opt/mssql_demo.sh
   ```
