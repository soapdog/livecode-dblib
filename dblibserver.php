<?php

/*
 Remote DB Lib Server

 */

 // Override the data below with your defaults
 $encryption_password = "";
 $user = "";
 $password = "";
 $db = "";
 $server = "localhost";

 // decrypt the post
 $post = $_POST_RAW;
 $post = openssl_decrypt($post, "aes-256-ctr", $encryption_password);


 $req = json_decode($post, true);

 if (isset($req["user"])) {
     $user = $req["user"];
 }

 if (isset($req["password"])) {
     $password = $req["password"];
 }

 if (isset($req["db"])) {
     $db = $req["db"];
 }


 $type = $req["type"];

 $retVal = [];

 $mysqli = new mysqli($server, $user, $password, $db);

 if (mysqli_connect_errno()) {
    $retVal["error"] = mysqli_connect_error();
 } else {
    switch($type) {
        case "execute":
            $query = $mysqli->query($sql);
            $retVal["affected_rows"] = $query->affected_rows;
            break;
        case "query":
            $query = $mysqli->query($sql);
            $data = $query->mysqli_fetch_array();
            $retVal["data"] = $data;
            $retVal["num_rows"] = $query->num_rows;
            break;            
    }
 }

 header('Content-Type: text/plain');
 $retVal = openssl_decrypt(json_encode($retVal), "aes-256-ctr", $encryption_password);

 echo $retVal;

 // encrypt the result