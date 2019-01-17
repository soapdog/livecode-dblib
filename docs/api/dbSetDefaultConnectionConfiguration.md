Sets the default _Database Connection Parameter_ for the calls. This is used to call remote servers without exposing their database servers to the internet.

## Parameters 

An array with the connection configuration with the following keys:

- `user`: a user to be passed to the server
- `password`: the password for the given user
- `encryption_password`: a password to encrypt the json sent to the server
- `cipher`: the cypher to be used (default is aes-256-ctr)
- `url`: the url pointing to the PHP file

## Example

~~~
put "johndoe" into tConfigA["user"]
put "mypass" into tConfigA["password"]
put "bhjbhzjfb" into tConfigA["encryption_password"]
put "https://example.com/remotelib.php" into tConfigA["url"]

dbSetDefaultConnectionConfiguration tConfigA
~~~