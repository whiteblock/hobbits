import Foundation

struct Request {
    let version: String
    let command: String
    let headers: [UInt8]
    let body: [UInt8]
}

func parse(request: String) -> Request {

    let result = request.split(separator: "\n")

    let requestLine = result[0]
    let payload = result[1]

    var r = requestLine.split(separator: " ")
    if r.count < 8 {
        r.append(" ")
    }

    let headersLength = Int(r[5])!
    let bodyLength = Int(r[6])!

    let headers = payload[..<payload.index(payload.startIndex, offsetBy: headersLength)]
    let body = payload[payload.index(payload.startIndex, offsetBy: headersLength)..<payload.index(payload.startIndex, offsetBy: bodyLength)]

    return Request(
        version: String(r[1]),
        command: String(r[2]),
        headers: [UInt8](headers.utf8),
        body: [UInt8](body.utf8)
    )
}

print(parse(request: "EWP 0.2 PING 0 5\n12345"))
