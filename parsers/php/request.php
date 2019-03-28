<?php

class ewp_request{
    public $proto;
    public $version;
    public $command;
    public $header;
    public $body;

    public function parse(string $raw) {
        $req_split = explode("\n",$raw,2);
        $given_request = explode(" ",$req_split[0]);
        $this->proto = $given_request[0];
        $this->version = $given_request[1];
        $this->command = $given_request[2];
        $this->header = substr($req_split[1],0,intval($given_request[5]));
        $this->body = substr($req_split[1],intval($given_request[5]),intval($given_request[6]));
    }

    public function marshal(){
        $out = $this->proto . " ". $this->version . " " . $this->command . " " . $this->compression .  " ";
        $out .= " ".strlen($this->header). " ".strlen($this->body);
        $out .= "\n".$this->header . $this->body;
        return $out;
    }
}

//Uncomment and run for example
/*
$test = new ewp_request;
$test->parse("EWP 0.2 PING 0 5\n12345");

print_r($test);

echo $test->marshal()."\n";*/
?>