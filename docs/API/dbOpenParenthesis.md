This command allows you to add an opening parenthesis to the where clause. This is useful when you need to group your where clauses. 

For example, suppose you want to search for emails that contain 'runrev.com' and the age is less 18 or more than 35. If you use a code like:

~~~
dbLike "email", "runrev.com"
dbWhere "age <", 18, "AND"
dbWhere "age >", 35, "OR"
~~~

You will end put with the following WHERE clause:
~~~
WHERE 'email' LIKE '%runrev.com%' AND 'age' < 18 OR 'AGE' > 35
~~~

Which is ambiguous and will return the wrong value, it will search for email like runrev and age less than 18 or just age greater than 35 so if some record has age 40, it will match even if the email is not from runrev.com.

If you add parenthesis as in this code:

~~~
dbLike "email", "runrev.com"
dbOpenParenthesis
dbWhere "age <", 18, "AND"
dbWhere "age >", 35, "OR"
dbCloseParenthesis
~~~

You will end put with the following WHERE clause:

~~~
WHERE 'email' LIKE '%runrev.com%' AND ( 'age' < 18 OR 'AGE' > 35 )
~~~

This SQL will execute as you expect because you are being clear on how the matches should go.

!> **Remember:** Add the close parenthesis with dbCloseParenthesis as well.
