#!/usr/bin/env python

class Request:
    def __init__(self, proto, version, command, headers, body):
        self.proto = proto
        self.version = version
        self.command = command
        self.headers = headers
        self.body = body

def req_parse(req):
    res = req.split("\n",1)
    reqLine = res[0]
    tmp = res
    for i in range (0,len(res)):
        if tmp[i] == "":
            tmp[i] = "\n"
    payload = "".join(tmp[1:])
    r = str.split(reqLine, " ")
    if len(r) < 8:
        r.append("")
    headersLen = int(r[3])
    bodyLen = int(r[4])
    headers = payload[0:headersLen]
    body = payload[headersLen:bodyLen+headersLen]

    request = Request(r[0],r[1],r[2],headers,body)
    return request.__dict__

def req_marshal(req):
    if isinstance(req,dict):
        proto = req.get("proto")
        version = req.get("version")
        command = req.get("command")
        headerLen = len(req.get("headers"))
        bodyLen = len(req.get("body"))
        headers = (req.get("headers"), "")[headerLen == 0]
        body = (req.get("body"), "")[bodyLen == 0]
        return ("{} {} {} {} {}\n{}{}").format(proto, version, command, headerLen, bodyLen, headers, body)
