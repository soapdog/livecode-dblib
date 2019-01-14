This command allows you to specify the SQL statement to use in the next function that queries the database.

Sometimes you need to write a complex SQL statement that is beyond what we offer with routines such as _dbWhere, dbLike, dbLimit_, in this cases you can still use our handy database functions but specify the SQL statement yourself. 

For example:

~~~
dbSetSQL "SELECT * FROM page, tags WHERE tags.page_id = page.id" 
put dbGet() into tPagesAndTagsArray 
~~~

Our commands and functions cover most of the common uses for application database usage
but if you need more you can always write your own SQL. The golden rule is: _if you know what a join is, then you can write it better than the library_.

## Parameters
* `dbSetSQL pSQL`: Sets the given SQL Statement as the next one to run.
* `dbSetSQL pSQL, pPlaceHoldersA`: Sets the given SQL Statement as the next one to run and uses the data from the given array.

!> **Be aware:** in the example code above, notice how [dbGet()](api/dbGet.md) is used without any parameter.