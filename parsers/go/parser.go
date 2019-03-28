package main

import (
	"fmt"
	"strconv"
	"strings"
)

type Request struct {
	proto   string
	version string
	command string
	headers []byte
	body    []byte
}

func reqParse(req string) Request {
	res := strings.Split(req, "\n")

	reqLine := res[0]
	payload := strings.Join(res[1:], "\n")
	r := strings.Split(reqLine, " ")
	if len(r) < 8 {
		r = append(r, " ")
	}
	headersLen, _ := strconv.Atoi(r[3])
	bodyLen, _ := strconv.Atoi(r[4])
	headers := payload[0:headersLen]
	body := payload[headersLen : headersLen+bodyLen]

	request := Request{
		proto:   r[0],
		version: r[1],
		command: r[2],
		headers: []byte(headers),
		body:    []byte(body),
	}
	return request
}

func reqMarshal(req Request) string {
	requestLine := fmt.Sprintf("%s %s %s %d %d",
		req.proto,
		req.version,
		req.command,
		len(req.headers),
		len(req.body))

	r := fmt.Sprintf("%s\n%s%s", requestLine, string(req.headers), string(req.body))
	return r
}
