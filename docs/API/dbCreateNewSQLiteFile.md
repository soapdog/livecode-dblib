This commands creates a new SQLite file at the given path and optionaly executes a given SQL

This can be used with CREATE TABLE calls or dumps from any SQLite client.

## Parameters:
* `dbCreateNewSQLiteFile pLocation`: The full location of the file including the file name and extension.
* `dbCreateNewSQLiteFile pLocation, pInitialSQL`: The full location of the file including the file name and extension and an optional SQL script to run.

If the initial SQL script is given then the result of running it is placed on _the result_. You should also check that variable for errors starting with _dberr_.
