#!/usr/bin/env python

class Request:
    def __init__(self, proto, version, command, compression, responseCompression, headOnlyIndicator, headers, body):
        self.proto = proto
        self.version = version
        self.command = command
        self.compression = compression
        self.responseCompression = responseCompression
        self.headOnlyIndicator = headOnlyIndicator
        self.headers = headers
        self.body = body

def parser(req):
    res = str.split(req,"\n")
    reqLine = res[0]
    payload = res[1]
    r = str.split(reqLine, " ")
    if len(r) < 8:
        r.append("")
    headersLen = int(r[5])
    bodyLen = int(r[6])
    headers = payload[0:headersLen]
    body = payload[headersLen:bodyLen]

    request = Request(r[0],r[1],r[2],r[3],str.split(r[4],","),r[7]=="H",headers,body)
    return request.__dict__

example_ping_req = "EWP 0.1 PING none none 0 5\n12345"
print(parser(example_ping_req))