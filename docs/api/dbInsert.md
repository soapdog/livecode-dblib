This function inserts a new record into the database.

It uses an array where each element is a field value with the same keys as the field names
on the database schema.

## Example

~~~
put "Andre" into tDataA["firstName"] 
put "Garzia" into tDataA["lastName"] 
put "andre@andregarzia.com" into tDataA["email"] 
put dbInsert("contacts", tDataA) into tResult 
~~~

Will insert a new record with the values from the array. This function works on the default connection id unless you specify an extra parameter with the desired connection id.

## Parameters
* `dbInsert pTable, pDataA, pDatabaseConnectionID`: A table name, a data array, and an optional connection id.

# Return
The result from the inner revExecuteSQL call.
