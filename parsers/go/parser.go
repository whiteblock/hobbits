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

type Response struct {
	responseStatus string
	compression    []string
	headers        string
	body           string
	hasBody        bool
}

func reqParse(req string) Request {
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
	return request
}

func reqMarshal(req Request) string {
	resCompression := strings.Join(req.responseCompression, ",")
	headLen := strconv.Itoa(len(req.headers))
	bodyLen := strconv.Itoa(len(req.body))
	var headOnlyIndicator string
	if req.headOnlyIndicator {
		headOnlyIndicator = " H"
	} else {
		headOnlyIndicator = ""
	}
	r := fmt.Sprintf("%s %s %s %s %s %s %s%s%s%s", req.proto, req.version, req.command, req.compression, resCompression, headLen, bodyLen, headOnlyIndicator, string(req.headers), string(req.body))
	return r
}

func resParse(res string) Response {
	var has_body bool
	r := strings.Split(res, " ")
	if len(r) < 4 {
		r = append(r, "")
		has_body = false
	}
	response := Response{
		responseStatus: r[0],
		compression:    strings.Split(r[1], ","),
		headers:        r[2],
		body:           r[3],
		hasBody:        has_body,
	}
	return response
}

func resMarshal(res Response) string {
	var body int
	compression := strings.Join(res.compression, ",")
	if res.hasBody {
		body = len(res.body)
	} else {
		body = 0
	}
	r := fmt.Sprintf("%s %s %s %b", res.responseStatus, compression, res.headers, body)
	return r
}
