Returns all data from a given table as an array.

You can use commands such as [dbWhere](api/dbWhere.md), [dbLike](api/dbLike.md), [dbLimit](api/dbLimit.md), [dbOrderBy](api/dbOrderBy.md) to refine queries returned by this function.

If a code like:

~~~
put dbGet("contacts") into tDataA
~~~

returns all the contacts. Then a code like:

~~~
dbWhere("country", "Brazil") 
dbWhere("sex", "male") 
put dbGet("contacts") into tDataA 
~~~

Will return all contacts that are male and from Brazil.

This functions works on the default connection id set with [dbSetDefaultConnectionID](api/dbSetDefaultConnectionID.md) unless you pass an _optional connection id_ argument.

## Parameters:

* `dbGet(pTableName)`: A table name.
* `dbGet(pTableName, pConnectionID)` A table name and a connection id.
