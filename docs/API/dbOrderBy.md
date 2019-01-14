Sets the ordering for a query.

~~~
dbOrderBy 'age' 
put dbGet("contacts") into tDataA 
~~~

Will return the contacts array ordered by age.

## Parameters
* `dbOrderBy pColumn`: A valid column or clause for the ordering.