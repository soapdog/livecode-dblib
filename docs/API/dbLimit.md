This command sets the limit for the query.

~~~
dbLimit 10 
put dbGet("contacts") into tDataA 
~~~

Will return up to ten contacts.

## Parameters
* `dbLimit pValue`: A valid number for the limit. 