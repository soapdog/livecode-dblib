This command allows you to refine your query. Use it before calling functions such as: [dbGet](api/dbGet.md), [dbUpdate](api/dbUpdate.md), [dbDelete](api/dbDelete.md).

If a code like:

~~~
put dbGet("contacts") into tDataA
~~~

returns all the contacts. Then a code like:

~~~
dbWhere "country", "Brazil" 
dbWhere "sex", "male" 
put dbGet("contacts") into tDataA 
~~~

Will return all contacts that are male and from Brazil.

The default operator for this is `=`.

~~~
dbWhere "country", "Brazil" 
~~~

Translates to:
~~~
WHERE country = 'Brazil' 
~~~

If you want to change the operator, then call it like:

~~~
dbWhere "age >", "21" 
~~~

Translates to:

~~~
WHERE age > 21 
~~~

You can have as many `dbWhere` calls as you want. When you finally call a function that touches the database, it will use all those _where clauses_.

!> **Remember:** after calling a function that touches the database such as [dbGet()](api/dbGet.md), all the query parameters are reset.

## Parameters

* `dbWhere pColumn, pValue`: a column and a value to look for.
* `dbWhere pColumn, pValue, pConcatenation`: a column, a value to look for, the concatenation operator for multiple `dbWhere` calls.

As a convention, the standard operator for multiple dbWhere calls is AND, so if you use

~~~
dbWhere "country", "Brazil" 
dbWhere "age >", "21" 
put dbGet("contacts") into tR 
~~~

Translates to the following SQL:

~~~
SELECT * FROM contacts WHERE country = 'Brazil' AND age > 21 
~~~

If you want to use `OR` instead of `AND`, you just pass an third optional parameter with
the operator you want, like:

~~~
dbWhere "country", "Brazil" 
dbWhere "age >", "21", "OR" 
put dbGet("contacts") into tR 
~~~

Translates to the following SQL:

~~~
SELECT * FROM contacts WHERE country = 'Brazil' OR age > 21
~~~

If you want to check if a column is null use a command like:

~~~
dbWhere "country", "NULL" 
~~~

If you want to check if a column is not null use a command like:

~~~    
dbWhere "country", "NOT NULL" 
~~~
