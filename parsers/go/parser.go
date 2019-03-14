package main

import (
	"fmt"
	"strconv"
	"strings"
)

type Request struct {
	proto               string
	version             string
	command             string
	compression         string
	responseCompression []string
	headOnlyIndicator   bool
	headers             []byte
	body                []byte
}

func parse(req string) []string {
	res := strings.Split(req, "\n")

	reqLine := res[0]
	payload := res[1]
	r := strings.Split(reqLine, " ")
	if len(r) < 8 {
		r = append(r, " ")
	}

	headersLen, _ := strconv.Atoi(r[5])
	bodyLen, _ := strconv.Atoi(r[6])
	headers := payload[0:headersLen]
	body := payload[headersLen:bodyLen]

	request := Request{
		proto:               r[0],
		version:             r[1],
		command:             r[2],
		compression:         r[3],
		responseCompression: strings.Split(r[4], ","),
		headOnlyIndicator:   r[7] == "H",
		headers:             []byte(headers),
		body:                []byte(body),
	}

	fmt.Println(request)

	return res
}

func main() {
	example_ping_req := "EWP 0.1 PING none none 0 5\n12345"
	parse(example_ping_req)
}
