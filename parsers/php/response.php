<?php

class ewp_response{
    public $response_status;
    public $compression;
    public $header; 
    public $body;
    public $has_body;

    function __construct(){
        $this->has_body = false;
    }

    public function parse(string $raw){
        $res_split = explode("\n",$raw,2);
        $given_response = explode(" ",$res_split[0]);
        $this->response_status = intval($given_response[0]);
        $this->compression = $given_response[1];
        $this->header = substr($res_split[1],0,intval($given_response[2]));
        if(sizeof($given_response) == 4){
            $this->has_body = true;
            $this->body = substr($res_split[1],intval($given_response[2]),intval($given_response[3]));
        }
    }

    public function marshal(){
        $out = "".$this->response_status." ".$this->compression." ".strlen($this->header);
        if($this->has_body){
            $out .= " ".strlen($this->header);
        }
        $out .= "\n".$this->header.$this->body;


        return $out;
    }
}


//Uncomment and run for example
/*
$test = new ewp_response;
$test->parse("200 none 5 5\n1234512345");

print_r($test);

echo $test->marshal()."\n";*/
?>