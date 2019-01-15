Updates a record in the database.

Use a [dbWhere](api/dbWhere.md) or a  [dbLike](api/dbLike.md) to specify which record. 

For example:

~~~
put "contato@andregarzia.com" into tNewDataA["email"] 
dbWhere "email", "andre@andregarzia.com" 
put dbUpdate("contacts", tNewDataA) into tResult
~~~

This will change the email for that user. It is analogous to executing the following SQL:

~~~
UPDATE 
  contacts 
SET 
  email = 'contato@andregarzia.com' 
WHERE 
  email = 'andre@andregarzia.com' 
~~~
    
!> **Attention:** If you don't specify a [dbWhere](api/dbWhere.md) or a [dbLike](api/dbLike.md) then the this call will return an error starting with `"dberr,"`. This is to protect you from accidently updating all records on a given table because you forgot to specify a filter.

This function works on the default connection id unless
you specify an extra parameter with the desired connection id.

## Parameters
* `dbUpdate pTable, pDataA, pDatabaseConnectionID` a table name and a data array, and an optional connection id.

## Returns
the result from the inner revExecuteSQL call.

