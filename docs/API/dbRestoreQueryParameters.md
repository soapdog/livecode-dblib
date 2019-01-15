This will restore the query parameters replacing the current parameters. You can use [dbPreserveQueryParameters](api/dbPreserveQueryParameters.md) to save the query parameters to an array.

## Example
~~~~
put dbPreserveQueryParameters() into tCurrentQueryDataA
doSomethingThatMakesAQuery()
dbRestoreQueryParameters(tCurrentQueryDataA)
~~~

In the code above, the call to `doSomethingThatMakesAQuery()` will not affect the query parameters that were being set before it was called because we save them and restore them afterwards.

## Parameters:
* `dbPreserveQueryParameters pQueryDataA`: An array with the query parameters.