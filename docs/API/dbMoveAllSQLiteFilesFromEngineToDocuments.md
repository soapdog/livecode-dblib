This command will copy the SQLite files from the engines folder to the documents.

You can pass an optional file extension for the SQLite files. If you don't pass one, then
_.sqlite_ is assumed to be the file extension. Files added to your Standalone using the "Copy Files" tab end up in the engine folder. This folder is not writable so it is not a good location for your database files. This command will copy the files from the engine folder to the documents folder. This folder is writable and backed up to iCloud on iPhone.

For example, suppose you have your SQLite file called _contacts.db_ and you added this file
to your Standalone using the *copy files* tab of the *Standalone builder settings*, then this code:

~~~
dbMoveAllSQLiteFilesFromEngineToDocuments ".db"
~~~

Will copy this file to the documents folder. Then after that you can simply access it using:

~~~
the documents folder & "/contacts.db" 
~~~

!> **Attention:** Be aware that if there is already a file in the destination with the same name, this command **WILL NOT** overwrite it. 

## Parameters
* `dbMoveAllSQLiteFilesFromEngineToDocuments pFileExtension`: The file extension you're using for your database files.