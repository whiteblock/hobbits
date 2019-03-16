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

class Response:
    def __init__(self, response_status, compression, headers, body, has_body):
        self.response_status = response_status
        self.compression = compression
        self.headers = headers
        self.body = body
        self.has_body = has_body

def req_parse(req):
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

def req_marshal(req):
    if isinstance(req,dict):
        proto = req.get("proto")
        version = req.get("version")
        command = req.get("command")
        compression = req.get("compression")
        responseCompression = ",".join(req.get("responseCompression"))
        headOnlyIndicator = ("", " H")[req.get("headOnlyIndicator")]
        headerLen = len(req.get("headers"))
        headers = (req.get("headers"), "")[headerLen == 0]
        bodyLen = len(req.get("body"))
        body = (req.get("body"), "")[bodyLen == 0]
        return ("{} {} {} {} {} {} {}{}{}{}").format(proto, version, command, compression, responseCompression, headerLen, bodyLen, headOnlyIndicator, headers, body)


def res_parse(res):
    res = res.rstrip()
    res = str.split(res, " ")
    if len(res) < 4:
        res.append("")
        has_body = False
    else:
        has_body = True
    res_status = res[0]
    compression = res[1]
    headers = res[2]
    body = res[3]
    
    response = Response(res[0],res[1],res[2],res[3],has_body)
    return response.__dict__

def res_marshal(res):
    if isinstance(res,dict):
        res_status = res.get("response_status")
        compression = res.get("compression")
        headers = res.get("headers")
        body = ("", " "+res.get("body"))[res.get("has_body")]
        return ("{} {} {}{}").format(res_status, compression, headers, body)
    elif isinstance(res,str):
        parsed = res_parse(res)
        return res_marshal(parsed)