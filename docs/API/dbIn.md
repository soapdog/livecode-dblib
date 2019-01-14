This command allows you to refine your query. Use it before calling functions such as: [dbGet](api/dbGet.md), [dbUpdate](api/dbUpdate.md), [dbDelete](api/dbDelete.md). It allows you to specify the `IN` part of a `WHERE` clause.

If a code like:

~~~
put dbGet("contacts") into tDataA 
~~~

returns all the contacts. Then a code like:

~~~
dbIn "country", "Brazil","US","France" 
put dbGet("contacts") into tDataA 
~~~

Will return all contacts that are from Brazil or the US or France. You can have as many `dbIn` calls as you want. When you finally call a function that touches
the database, it will use all those _where clauses_.

!> **Remember:** after calling a function that touches the database such as dbGet(), all the query parameters are reset.

## Parameters
* `dbIn pColumn, <multiple values>`: a column and values to look for.
* `dbIn pColumn, <multiple values>, pConcatenationOperator`: a column, values to look for and a concatenation operator.

As a convention, the standard operator for multiple `dbIn` calls is `AND` so if you call

~~~
dbIn "country", "Brazil","US","France" 
dbIn "country", "Germany","Argentina" 
put dbGet("contacts") into tR 
~~~

Translates to the following SQL:
~~~
SELECT
  * 
FROM 
  contacts 
WHERE 
  country IN('Brazil', 'US', 'France') and 
  country IN('Germany','Argentina') 
~~~

Now, if you want  to use `OR` instead of `AND`, you just pass an last extra parameter with the operator you want, like:

~~~
dbIn "country", "Brazil","US","France" 
dbIn "country", "Germany","Argentina","OR" 
put dbGet("contacts") into tR 
~~~

Translates to the following SQL:

~~~
SELECT 
  * 
FROM 
  contacts 
WHERE 
  country IN('Brazil', 'US', 'France') or 
  country IN('Germany','Argentina') 
~~~