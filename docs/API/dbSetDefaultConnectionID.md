Sets the default _Database Connection ID_ for the calls.

## Parameters:
* `dbSetDefaultConnectionID pID`: You pass the connection id number.

This _id_ is what the [LiveCode Database Opening routines return](https://livecode.com/resources/api/#livecode_script/revopendatabase). 

## Example:

~~~
get revOpenDatabase("mysql", "www.example.com", "RatesDB", myUsr, myPass)
if it is a number then
  dbSetDefaultConnectionID it
end if
~~~