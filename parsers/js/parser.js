const example_ping_req = "EWP 0.1 PING none none 0 5\n12345";

// req is a string
function parse(req) {
    let [ reqLine, payload ] = req.split('\n')
    let r = reqLine.split(' ')
    let headersLen = parseInt(r[5])
    let bodyLen = parseInt(r[6])
    let headers = payload.slice(0, headersLen)
    let body = payload.slice(headersLen, bodyLen)

    return {
        proto: r[0],
        version: r[1],
        command: r[2],
        compression: r[3],
        responseCompression: r[4].split(','),
        headOnlyIndicator: r[7] === 'H',
        headers,
        body
    }
}

function test() {
    console.log(parse(example_ping_req))
}
test()
