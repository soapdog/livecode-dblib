<?php

/*
 Remote DB Lib Server

*/

 // Override the data below with your defaults
 $encryption_key = "FFFFFFFFFFFFDDCCFFFFFFFFFFFFDDCC";
 $user = "test_dblib";
 $password = "supersecret";
 $dbname = "agarzia";
 $server = "localhost";
 $database_type = "mysql";
 $cipher = "AES-256-CTR"; // do not change cipher unless you know what you're doing

 // Disable errors display
 ini_set('display_errors', 1); // set to false == disable display.
 
 require_once("idiorm.php");

/* Auxiliary function */

 function debug($msg) {
     $debug = true;
     if ($debug) {
         error_log("[DB LIB] $msg");
     }
 }

 // decrypt the post
 $post = file_get_contents('php://input');
 $post = openssl_decrypt($post, $cipher, $encryption_key);

 if (!$post) {
     debug("error on decrypt");
     debug(openssl_error_string());
 }

 debug("Post: $post");
 $req = json_decode($post, true);

 if (json_last_error() !== JSON_ERROR_NONE) {
     $error = json_last_error();
 }

 if (isset($req["user"])) {
     $user = $req["user"];
 }

 if (isset($req["password"])) {
     $password = $req["password"];
 }

 if (isset($req["db"])) {
     $dbname = $req["db"];
 }

 if (isset($req["database_type"])) {
     $database_type = $req["database_type"];
 }

 ORM::configure("${database_type}:host=${server};dbname=${dbname}");
 ORM::configure('username', $user);
 ORM::configure('password', $password);

 $sql = $req["sql"];
 $type = $req["type"];
 $retVal = [];

 switch($type) {
     case "query":
        if (isset($req["placeholders"])) {
            $retVal = ORM::for_table($req["table"])->raw_query($sql, $req["placeholders"])->find_array();
        } else {
            $retVal = ORM::for_table($req["table"])->raw_query($sql)->find_array();
        }
     break;
     case "execute":
      if (isset($req["placeholders"])) {
            $retVal = ORM::raw_execute($sql, $req["placeholders"]);
        } else {
            $retVal = ORM::raw_execute($sql);
        }
     break;
     default:
     break;
 }

 $retVal = json_encode($retVal);
 debug("Response: ${retVal}");


 header('Content-Type: text/plain+dblib');
 $retVal = openssl_encrypt($retVal, $cipher, $encryption_key);

 echo $retVal;

