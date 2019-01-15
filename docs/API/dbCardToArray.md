This command will look into the current card for fields, buttons and groups
with the same name as the fields on a given database table. If it finds the correct controls it picks their values and assemble an array to be used by the database touching functions.

If you have a card with a field called "firstName", a field called "lastName" and a menu button called "country" which are all fields on your _contacts_ table and you use:

~~~
put dbCardToArray("contacts") into tDataA 
~~~

it is the same as writing:

~~~
put textencode(field "firstName", "UTF8") into tDataA["firstName"] 
put textencode(field "lastName", "UTF8") into tDataA["lastName"] 
put the label of button "country" into tDataA["country"] 
~~~

So it follows these rules:

- it looks for a field, it there is one, then it picks the value and place it into the array.
- it looks for a button and places the label into the array.
- it looks for a group and places the value from the custom property _dbvalue_ into the array.

!> **Clue:** if you're using groups for your mobile controls, just script a _setprop dbvalue_ and
a _getprop dbvalue_ for the group to be able to exchange data with this command.

## Parameters
* `dbCardToArray pTableName`: a table name.
* `dbCardToArray pTableName, pConnectionID`: a table name and a connection id.

## Returns
* an array