#!/bin/bash

MSSQL_test() {
        #Test connection
        read -p "
        Testing the connection using: 
        sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -Q 'SELECT name FROM sys.databases
        GO'"
        echo ""
        sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -Q "SELECT name FROM sys.databases
        GO"
        echo ""
}

DB_restore() {
        #Restore the AdventureWorks2022 DB
        read -p "
        We will restore the example
        AdventureWorks2022 DB using:

        sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -i /opt/restore.sql
        for some reason this needs selinux disabled to work, but we'll 
        turn it back on afterwards"
        echo ""
        setenforce 0
        sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -i /opt/restore.sql
        setenforce 1
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
        sqlcmd -S localhost -U sa -P 'Pizzaisg00d!' -C -Q "SELECT *
        FROM AdventureWorks2022.INFORMATION_SCHEMA.TABLES;
        go"
        echo ""
}

MSSQL_test
DB_restore
DB_test

read -p "That's all folkes"
echo "See ya"
