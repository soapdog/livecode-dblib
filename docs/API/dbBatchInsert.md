This function performs batch inserts. You pass the table name, the batch data array and an optional database connection id. The batch data array is an array like the one used by the datagrid. On its first level it has numeric keys going from 1 to N. In each element in the second level it has a data array.

## Example
~~~
put "andre" into tDataA[1]["first_name"]
put "garzia" into tDataA[1]["last_name"]
put "support@andregarzia.com" into tDataA[1]["email"]

put "claudia" into tDataA[2]["first_name"]
put "donovan" into tDataA[2]["last_name"]
put "claudia@example.com" into tDataA[2]["email"]

get dbBatchInsert("contacts", tDataA)
~~~

The return value is the number of records added or an error string that starts with __dberr,__.

## Parameters

* `dbBatchInsert pTable, pBatchDataA, [pDatabaseConnectionID]`: table name, data array and an optional connection id.
   