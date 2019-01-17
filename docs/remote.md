
<iframe src="https://player.vimeo.com/video/220531208" width="640" height="480" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

# Background & Context
[DB Lib](/livecode/dblib) is a minimalistic database library for LiveCode that works on Desktop and Mobile and allows
you to build database-savvy apps without writing SQL directly. This post is to introduce a **great new feature called Remote DB Lib**. As you may know from posts on the _How To Use LiveCode_ mailing list and forums, many developers would like to use DB Lib in their apps over the internet. Like all other database libraries that work on top of RevDB, DB Lib can connect directly to the database server to work. Unfortunately this is not a good solution for apps that work over the internet since **exposing RDBMS to the internet at large is a huge security risk**.

So this library has an enhancement that allows you to connect from LiveCode to a remote server without exposing your RDBMS. This  works alongside a matching PHP file on your server, it is this PHP file that actually talks to the database server. The _DB Lib_ calls are collected on an encrypted message that is sent to the PHP file where it is decrypted and executed. This uses _state of the art AES 256 encryption_  (you can also add a free SSL certificate from [Let's Encrypt](https://letsencrypt.com) to add even more security) to protect your data.

# Usage

Using this feature is very simple.

## Step 1 - upload files to your server
You need to upload both PHP files to your server. They are called `dblibserver.php` and `idiorm.php`. Setting up your server for PHP and some RDBMS is beyond the scope of this help but there are very good guides from [Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu).

## Step 2 - customize the setup
You must add your database configuration data to the PHP file, customize the encryption key used in both the PHP file and your LiveCode setup and you're good to go, for example, this is the LiveCode setup:

```
put "https://andregarzia.com/auxiliary/dblibserver.php" into tConfigA["url"] // URL
put "FFFFFFFFFFFFDDCCFFFFFFFFFFFFDDCC" into tConfigA["encryption_key"] // Encryption Key
dbSetDefaultConnectionConfiguration tConfigA
``` 
check the documentation for [dbGetDefaultConnectionConfiguration](api/dbGetDefaultConnectionConfiguration.md), and also customize the PHP file:

```
// Override the data below with your defaults
$encryption_key = "FFFFFFFFFFFFDDCCFFFFFFFFFFFFDDCC"; // Same as LiveCode side
$user = "test_user"; // customize user, password, db...
$password = "mypassword";
$db = "test";
$server = "localhost";
$cipher = "AES-256-CTR"; // do not change cipher unless you know what you're doing
```

After configuring them, you can just issue normal DB Lib commands such as:

```
put dbGet("test_contacts") into tRetValA
put jsonexport(tRetValA) into fld 1
```

