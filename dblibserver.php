<?php

/*
 Remote DB Lib Server

 */

 // Override the data below with your defaults
 $encryption_key = "FFFFFFFFFFFFDDCCFFFFFFFFFFFFDDCC";
 $user = "test_dblib";
 $password = "supersecret";
 $db = "agarzia";
 $server = "localhost";
 $cipher = "AES-256-CTR"; // do not change cipher unless you know what you're doing

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
     $db = $req["db"];
 }

 $sql = $req["sql"];


 $type = $req["type"];

 $retVal = [];

 $mysqli = new mysqli($server, $user, $password, $db);

 if (mysqli_connect_errno()) {
    $retVal["error"] = mysqli_connect_error();
 } else {
    switch($type) {
        case "execute":
            if (isset($req["placeholders"])) {
                // replace :x with ? in sql
                for($i = 1; $i <= count($req["placeholders"]); $i++) {
                    $sql = str_replace(":$i", "?", $sql);
                }
                debug("Prepared statement sql: $sql");
                $stmt = $mysqli->prepare($sql);
                $bindstr = "";
                $n = count($req["placeholders"]);
                for($i = 1; $i <= $n; $i++) {
                   $bindstr .= "s";
                }
                
                $a_params[] = & $bindstr;

                for($i = 1; $i <= $n; $i++) {
                    /* with call_user_func_array, array params must be passed by reference */
                    $a_params[] = & $req["placeholders"][$i];
                }
                call_user_func_array(array($stmt, 'bind_param'), $a_params);
                $succ = $stmt->execute();
                if ($succ) {
                    $retVal["affected_rows"] = $query->affected_rows;
                } else {
                    $retVal["error"] = $stmt->error;
                    $retVal["sql"] = $sql;
                }

                $stmt->close();

            } else {
                $query = $mysqli->query($sql);
                if (!$query) {
                    $retVal["error"] = $mysqli->error;
                    $retVal["sql"] = $sql;
                } else {
                    $retVal["affected_rows"] = $query->affected_rows;
                    $query->close();
                }
            }
            $mysqli->close();
            
            break;
        case "query":
            try {
                $query = $mysqli->query($sql);

                if (!$query) {
                    $retVal["error"] = $mysqli->error;
                    $retVal["sql"] = $sql;
                } else {

                    while($row = $query->fetch_array(MYSQLI_ASSOC)) {
                        $rows[] = $row;
                    }                
                    
                    $retVal["data"] = $rows;
                    $retVal["num_rows"] = $query->num_rows;
                    $query->close();
                }
                $mysqli->close();
            } catch(Exception $e) {
                $retVal["error"] = "Exception in query";
            }
            break;            
    }
 }

 header('Content-Type: text/plain+dblib');
 $retVal = openssl_encrypt(json_encode($retVal), $cipher, $encryption_key);

 echo $retVal;

