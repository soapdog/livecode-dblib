This will return the current query parameters. You can use [dbRestoreQueryParameters](api/dbRestoreQueryParameters.md) to restore it later. This is useful when you're creating routines and don't want other queries to pollute your current query parameters.

## Example
~~~~
put dbPreserveQueryParameters() into tCurrentQueryDataA
doSomethingThatMakesAQuery()
dbRestoreQueryParameters(tCurrentQueryDataA)
~~~

In the code above, the call to `doSomethingThatMakesAQuery()` will not affect the query parameters that were being set before it was called because we save them and restore them afterwards.

## Returns 
* An array with the current parameters.