
static EXAMPLE_PING_REQ: &[u8] = b"EWP 0.1 PING none none 0 5\n12345";

#[derive(Clone,Debug)]
struct EWPRequest {
    version: String,
    command: String,
    compression: String,
    response_compression: Vec<String>,
    head_only_indicator: bool,
    headers: Vec<u8>,
    body: Vec<u8>
}
impl EWPRequest {
    fn parse(req: &[u8]) -> Result<Self, std::io::Error> {
        let parts: Vec< &[u8] > = req.splitn(2, |chr| chr == &('\n' as u8) ).collect();
        let req_line: String = String::from_utf8(parts[0].to_vec()).map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let r: Vec<String> = req_line.splitn(8, |chr| chr == ' ').map(|s| s.to_string()).collect();
        let payload = parts[1];
        assert!(&r[0] == "EWP");
        assert!(&r[1] == "0.1");
        let headers_len = r[5].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let body_len = r[6].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;

        //let r = req.clone().split(" ").collect();
        Ok(Self {
            version: "0.1".to_string(),
            command: r[2].clone(),
            compression: r[3].clone(),
            response_compression: r[4].split(|chr| chr == ',').map(|s| s.to_string()).collect(),
            head_only_indicator: r.get(7) == Some(&"H".to_string()),
            headers: payload[0..headers_len].to_vec(),
            body: payload[headers_len..body_len].to_vec(),
        })
    }
}

fn main() {
    let req = EWPRequest::parse(EXAMPLE_PING_REQ).expect("parse failed");
    println!("{:#?}", req)
}
