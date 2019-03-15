<?php

require_once("response.php");
require_once("request.php");

if(sizeof($argv) != 3){
    exit("Invalid number of arguments.\n");
}

$size = intval($argv[2]);
$type = $argv[1];

$resSTDIN = fopen("php://stdin","r");

$ewp = fread($resSTDIN,$size);

fclose($resSTDIN);

if($type == "response"){
    $test = new ewp_response;
    $test->parse($ewp);
    echo $test->marshal();
}else if($type == "request"){
    $test = new ewp_request;
    $test->parse($ewp);
    echo $test->marshal();
}
?>