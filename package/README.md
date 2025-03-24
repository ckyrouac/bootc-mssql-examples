# rhel-mssql-bootc

To run this example:

1. Deploy a rhel9 system
2. Clone this repo onto the system
3. Download the AdventureWorks sample data into the opt directory
   `curl -o ./opt/demo/AdventureWorks2022.bak -L https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak`
4. `podman pull mcr.microsoft.com/mssql/rhel/server:2022-latest`
5. `cd mssql-lbi && podman build . -t quay.io/<user>/mssql-lbi`
6. `podman push quay.io/<user>/mssql-lbi`
7. `system-reinstall-bootc quay.io/ckyrouac/mssql-lbi`
8. `reboot`
9. `systemctl status mssql.service`
10. `/opt/demo/mssql_demo.sh` to validate the service is working
