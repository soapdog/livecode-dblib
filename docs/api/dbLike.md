This command allows you to refine your query. Use it before calling functions such as: [dbGet](api/dbGet.md), [dbUpdate](api/dbUpdate.md), [dbDelete](api/dbDelete.md).

If a code like:
~~~
put dbGet("contacts") into tDataA 
~~~

returns all the contacts. Then a code like:

~~~
dbLike "email", "runrev.com" 
put dbGet("contacts") into tDataA 
~~~

Will return all contacts with emails from runrev.com
The default matching routine for this _contains_.  

~~~
dbLike "email", "runrev.com" 
~~~

Translates to:

~~~
WHERE email LIKE '%runrev.com%' 
~~~

If you want to change the matching routines, then call it like:

~~~
dbLike "name", "john", "after" 
~~~

Translates to:

~~~
WHERE name LIKE 'john%' 
~~~

This will return all contacts with names starting with John. You can also use 
'exact' as the matching routine to strip the wildcards and match the exact value.
You can have as many dbLike calls as you want. When you finally call a function that touches the database, it will use all those _where clauses_.

!> **Remember:** after calling a function that touches the database such as [dbGet()](api/dbGet.md), all the query parameters are reset.

## Parameters
* `dbLike pColumn, pValue`: a column and a value to look for.
* `dbLike pColumn, pValue, pWildcard`: a column, a value to look for and where to put the wildcard.
* `dbLike pColumn, pValue, pWildcard, pConcatenationOperator`: a column, a value to look for, where to put the wildcard and how to concatenate calls.

As a convention, the standard operator for multiple dbWhere calls is AND
so if you call

~~~
dbLike "email", "runrev.com" 
dbLike "first_name", "Kevin" 
put dbGet("contacts") into tR
~~~ 

Translates to the following SQL:

~~~
SELECT * FROM contacts WHERE email LIKE '%runrev.com%' AND first_name LIKE '%Kevin%' 
~~~

Now, if you want  to use OR instead of AND, you just pass an fourth extra parameter with the operator you want, like:

~~~
dbLike "email", "runrev.com" 
dbLike "first_name", "Kevin", "after", "OR" 
put dbGet("contacts") into tR 
~~~

Translates to the following SQL:

~~~
SELECT * FROM contacts WHERE email LIKE '%runrev.com%' OR first_name LIKE 'Kevin%' 
~~~

Can also pass the matching operator and the concatenation operator.