
This command executes the given SQL script on the default connection or the given connection.

## Parameters
* `dbExecuteSQL pSQL`: Executes A SQL Statement.
* `dbExecuteSQL pSQL, pDatabaseConnection`: Executes a SQL Statement in a given connection id.

!> Be aware that this is to be used with **SQL that doesn't return data sets**. If you want to query the database with a complex handwritten query, use [dbSetSQL](api/dbSetSQL.md). 