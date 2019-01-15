This command allows you to refine your query. Use it before calling functions such as: [dbGet](api/dbGet.md), [dbUpdate](api/dbUpdate.md), [dbDelete](api/dbDelete.md). It allows you to specify the `NOT IN` part of a `WHERE` clause.

If a code like:

~~~
put dbGet("contacts") into tDataA 
~~~

returns all the contacts. Then a code like:

~~~
dbNotIn "country", "Brazil","US","France" 
put dbGet("contacts") into tDataA 
~~~

Will return all contacts that **are not** from Brazil or the US or France. You can have as many `dbNotIn` calls as you want. When you finally call a function that touches
the database, it will use all those _where clauses_.

!> **Remember:** after calling a function that touches the database such as dbGet(), all the query parameters are reset.

## Parameters
* `dbNotIn pColumn, <multiple values>`: a column and values to look for.
* `dbNotIn pColumn, <multiple values>, pConcatenationOperator`: a column, values to look for and a concatenation operator.

As a convention, the standard operator for multiple `dbNotIn` calls is `AND` so if you call

~~~
dbNotIn "country", "Brazil","US","France" 
dbNotIn "country", "Germany","Argentina" 
put dbGet("contacts") into tR 
~~~

Translates to the following SQL:
~~~
SELECT
  * 
FROM 
  contacts 
WHERE 
  country NOT IN('Brazil', 'US', 'France') and 
  country NOT IN('Germany','Argentina') 
~~~

Now, if you want  to use `OR` instead of `AND`, you just pass an last extra parameter with the operator you want, like:

~~~
dbNotIn "country", "Brazil","US","France" 
dbNotIn "country", "Germany","Argentina","OR" 
put dbGet("contacts") into tR 
~~~

Translates to the following SQL:

~~~
SELECT 
  * 
FROM 
  contacts 
WHERE 
  country NOT IN('Brazil', 'US', 'France') or 
  country NOT IN('Germany','Argentina') 
~~~