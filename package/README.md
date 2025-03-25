# rhel-mssql-bootc

To run this example:

1. Deploy a rhel9 system and install the dependencies. An easy way is to use the AWS EC2 console to deploy a free tier RHEL9 image. Make sure to use at least 30GB of disk space and 2GB of memory.
   ```
   $ sudo su
   # dnf -y install git podman
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
1. Build the bootc image. Tag it with a repo of your chosing.
   ```sh
   podman login registry.redhat.io
   podman build . -t quay.io/<user>/bootc-mssql-example
   ```
1. Push the bootc image to the remote repo.
   ```sh
   podman login quay.io
   podman push quay.io/<user>/bootc-mssql-example
   ```
1. Install the bootc image to the existing system. Note: this will overwrite the existing system with the bootc image. I recommend doing this test in a VM.
   ```sh
   system-reinstall-bootc quay.io/<user>/bootc-mssql-example
   ```
1. Reboot into the bootc image.
   ```sh
   reboot
   ```
1. SSH back into the image. Note the system is now accessed as the root user.
   ```sh
   ssh -i <keyfile> root@<hostname>
   ```
1. Verify the mssql service started succesfully.
   ```sh
   systemctl status mssql-server.service
   ```
1. Run the included demo script to validate mssql is behaving correctly.
   ```sh
   /opt/mssql_demo.sh
   ```
