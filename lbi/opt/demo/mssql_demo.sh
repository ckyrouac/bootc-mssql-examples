#!/bin/bash

MSSQL_test() {
        #Test connection
        read -p "
        Testing the connection using: 
        podman run -it mssql '/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -Q 'SELECT name FROM sys.databases
        GO'"
        echo ""
        podman exec -it mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -Q 'SELECT name FROM sys.databases'
        echo ""
}

DB_restore() {
        #Restore the AdventureWorks2022 DB
        read -p "
        We will restore the example
        AdventureWorks2022 DB using:

        sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -i /opt/restore.sql"

        echo ""

        podman exec -it mssql /opt/mssql-tools18/bin/sqlcmd  -S localhost -U sa -P 'Pizzaisg00d!' -C -i /opt/demo/restore.sql
        echo ""
}

DB_test() {
        #now let's show a table
        read -p "
        Showing a more real query
        SELECT *
        FROM AdventureWorks2022.INFORMATION_SCHEMA.TABLES;
        go
        "
        echo ""

        podman exec -it mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -Q 'SELECT * FROM AdventureWorks2022.INFORMATION_SCHEMA.TABLES;'

        echo ""
}

MSSQL_test
DB_restore
DB_test

read -p "That's all folkes"
echo "See ya"
