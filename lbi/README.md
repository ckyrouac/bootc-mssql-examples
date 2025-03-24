# Deploy mssql as a Logically Bound Image on a bootc system

This is an example of how to deploy an mssql server using bootc. In this example the mssql service is running as a container and is lifecycle bound to the bootc image as a [logically bound image](https://containers.github.io/bootc/logically-bound-images.html).

To run this example:


1. Deploy a rhel9 system and install the dependencies. An easy way is to use the AWS EC2 console to deploy a free tier RHEL9 image. Make sure to use at least 30GB of disk space and 2GB of memory.
   ```
   $ sudo su
   # dnf -y install git podman
   ```
2. Clone this repo onto the system
   ```
   # git clone https://github.com/ckyrouac/bootc-mssql-examples.git
   # cd bootc-mssql-examples/lbi
   ```
3. Download the AdventureWorks sample data into the opt directory
   ```
   # curl -o ./opt/demo/AdventureWorks2022.bak -L https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak
   ```
4. Pull the mssql container image that will be included in the bootc system
   ```
   # podman pull mcr.microsoft.com/mssql/rhel/server:2022-latest
   ```
5. Build the bootc image. Tag it with a repo of your chosing.
   ```
   # podman build . -t quay.io/<user>/bootc-mssql-example-lbi
   ```
6. Push the bootc image to the remote repo.
   ```
   # podman login quay.io
   # podman push quay.io/<user>/bootc-mssql-example-lbi
   ```
7. Install the bootc image to the existing system. Note: this will overwrite the existing system with the bootc image. I recommend doing this test in a VM.
   ```
   # system-reinstall-bootc quay.io/<user>/bootc-mssql-example-lbi
   ```
8. Reboot into the bootc image.
   ```
   # reboot
   ```
9. SSH back into the image. Note the system is now accessed as the root user.
   ```
   # ssh -i <keyfile> root@<hostname>
   ```
10. Verify the mssql service started succesfully.
    ```
    # systemctl status mssql.service
    ```
11. Run the included demo script to validate mssql is behaving correctly.
    ```
    # /opt/demo/mssql_demo.sh
    ```
