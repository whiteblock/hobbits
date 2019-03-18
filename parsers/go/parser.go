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
	compression    string
	headers        []byte
	body           []byte
	hasBody        bool
}

func reqParse(req string) Request {
	res := strings.Split(req, "\n")

	reqLine := res[0]
	payload := strings.Join(res[1:],"\n")
	r := strings.Split(reqLine, " ")
	if len(r) < 8 {
		r = append(r, " ")
	}
	headersLen, _ := strconv.Atoi(r[5])
	bodyLen, _ := strconv.Atoi(r[6])
	headers := payload[0:headersLen]
	body := payload[headersLen:headersLen+bodyLen]

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
	var headOnlyIndicator string
	if req.headOnlyIndicator {
		headOnlyIndicator = " H"
	} else {
		headOnlyIndicator = ""
	}
	requestLine := fmt.Sprintf("%s %s %s %s %s %d %d%s",
		req.proto, 
		req.version, 
		req.command, 
		req.compression, 
		resCompression,
		len(req.headers),
		len(req.body),
		headOnlyIndicator)
	
	r := fmt.Sprintf("%s\n%s%s",requestLine,string(req.headers), string(req.body))
	return r
}

func resParse(res string) Response {
	hasBody := false
	tmp := strings.Split(res,"\n")

	resLine := tmp[0]
	resBody := strings.Join(tmp[1:],"\n")
	responseLineArr := strings.Split(resLine, " ")
	headerLen,err := strconv.Atoi(responseLineArr[2])
	if err != nil{
		panic(err)
	}
	header := resBody[0:headerLen]
	body := ""
	if len(responseLineArr) == 4 {
		hasBody = true
		bodyLen,err := strconv.Atoi(responseLineArr[3])
		if err != nil{
			panic(err)
		}
		body = resBody[headerLen:(headerLen+bodyLen)]
	}
	response := Response{
		responseStatus: responseLineArr[0],
		compression:    responseLineArr[1],
		headers:        []byte(header),
		body:           []byte(body),
		hasBody:        hasBody,
	}
	return response
}

func resMarshal(res Response) string {

	out := fmt.Sprintf("%s %s %d", res.responseStatus, res.compression, len(res.headers))

	if res.hasBody {
		out += fmt.Sprintf(" %d",len(res.body));
	}
	out += fmt.Sprintf("\n%s%s",string(res.headers),string(res.body))
	return out
}
