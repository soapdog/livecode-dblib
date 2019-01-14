This command receives a comma separated list of column names that you want to be included in your next database call. By default, database queries include all columns. This behavior can be changed with this command.

## Parameters
* `dbColumns pColumns`: a comma separated list of column names.

## Example

~~~
dbColumns "name, phone"
put dbGet("contacts") into tContactsA
~~~