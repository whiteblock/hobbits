import Foundation

struct Request {
    let proto: String
    let version: String
    let command: String
    let compression: String
    let responseCompression: String
    let headOnlyIndicator: Bool
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
        proto: String(r[0]),
        version: String(r[1]),
        command: String(r[2]),
        compression: String(r[3]),
        responseCompression: String(r[4]).split(separator: " "),
        headOnlyIndicator: String(r[7]) == "H",
        headers: headers.utf8,
        body: body.utf8
    )
}
