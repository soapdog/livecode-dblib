This command will loop the keys of an array looking for controls with the same name in the current card. If it finds a field, button or group with the same name, it will try to replace the current value for the control with the value from the array.

If you have a card with a field called "firstName", a field called "lastName" and a menu button called "country" which are all fields on your _contacts_ table and you use:

~~~
dbArrayToCard tDataA 
~~~

it is the same as writing:

~~~
put textdecode(tDataA["firstName"], "UTF8") into field "firstName"
put textdecode(tDataA[ "lastName"], "UTF8") into field "lastName"
set the label of button "country" to tDataA["country"] 
~~~

So it follows these rules:
1 - it looks for a field, it there is one, then it sets the unicodetext property.
2 - it looks for a button and sets the label.
3 - it looks for a group and sets the value from the custom property _dbvalue_.

!> **Clue:** if you're using groups for your mobile controls, just script a _setprop dbvalue_ and a _getprop dbvalue_ for the group to be able to exchange data with this command.

## Parameters
* `dbArrayToCard pDataA`: an array from a db record to be inserted into the current card.

