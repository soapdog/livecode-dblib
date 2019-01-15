Sets the grouping options for a query.

~~~
dbGroupBy 'country' 
dbColumn 'count(1) as qty'
put dbGet("contacts") into tDataA 
~~~

Will return the contacts array grouped by country.

## Parameters
* `dbGroupBy pColum`: A valid column or clause for the grouping.