Deletes a record from the database.

!> **Attention:** Use a [dbWhere](api/dbWhere.md) or a [dbLike](api/dbLike.md) to specify which record(s) to delete.

For example:

~~~
dbWhere "email", "andre@andregarzia.com" 
put dbDelete("contacts") into tResult
~~~

This will delete that user. It is analogous to executing the following SQL:

~~~
DELETE FROM contacts WHERE email = 'andre@andregarzia.com' 
~~~
    
!> **Attention:** If you don't specify a [dbWhere](api/dbWhere.md) or a [dbLike](api/dbLike.md) then the library will return an
error for this call starting with `"dberr,"`. This is to protect you from accidently deleting all records on a given table because you forgot to specify a filter.

This function works on the default connection id unless
you specify an extra parameter with the desired connection id.

## Parameters
* `dbDelete pTable, [pDatabaseConnectionID]` a table name, and an optional connection id.

## Returns
the result from the inner `revExecuteSQL` call.
