<?php

class ewp_request{
    public $proto;
    public $version;
    public $command;
    public $compression;
    public $response_compression;
    public $head_only_indicator;
    public $header;
    public $body;

    public function parse(string $raw) {
        $req_split = explode("\n",$raw,2);
        $given_request = explode(" ",$req_split[0]);
        $this->proto = $given_request[0];
        $this->version = $given_request[1];
        $this->command = $given_request[2];
        $this->compression = $given_request[3];
        $this->response_compression = explode(",",$given_request[4]);
        $this->head_only_indicator = (sizeof($given_request) == 8 && $given_request[7] == "H");
        $this->header = substr($req_split[1],0,intval($given_request[5]));
        $this->body = substr($req_split[1],intval($given_request[5]),intval($given_request[6]));
    }

    public function marshal(){
        $out = $this->proto . " ". $this->version . " " . $this->command . " " . $this->compression .  " ";
        for ($i=0; $i < sizeof($this->response_compression) ; $i++) { 
            if($i != 0) {
                $out .= ",";
            }
            $out .= $this->response_compression[$i];
        }
        $out .= " ".strlen($this->header). " ".strlen($this->body);
        if($this->head_only_indicator) {
            $out .= " H";
        }
        $out .= "\n".$this->header . $this->body;
        return $out;
    }
}

//Uncomment and run for example
/*
$test = new ewp_request;
$test->parse("EWP 0.1 PING none none 0 5\n12345");

print_r($test);

echo $test->marshal()."\n";*/
?>