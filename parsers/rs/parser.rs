use std::env;
use std::io::{self, Read};


static EXAMPLE_PING_REQ: &[u8] = b"EWP 0.1 PING none none 0 5\n12345";

#[derive(Clone,Debug)]
pub struct EWPRequest {
    pub version: String,
    pub command: String,
    pub compression: String,
    pub response_compression: Vec<String>,
    pub head_only_indicator: bool,
    pub headers: Vec<u8>,
    pub body: Vec<u8>
}


impl EWPRequest {
    pub fn parse(req: &[u8]) -> Result<Self, std::io::Error> {
        let parts: Vec< &[u8] > = req.splitn(2, |chr| chr == &('\n' as u8) ).collect();
        let req_line: String = String::from_utf8(parts[0].to_vec()).map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let r: Vec<String> = req_line.splitn(8, |chr| chr == ' ').map(|s| s.to_string()).collect();
        let payload = parts.get(1);
        assert!(&r[0] == "EWP");
        assert!(&r[1] == "0.1");
        let headers_len = r[5].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let body_len = r[6].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;

        Ok(Self {
            version: "0.1".to_string(),
            command: r[2].clone(),
            compression: r[3].clone(),
            response_compression: r[4].split(|chr| chr == ',').map(|s| s.to_string()).collect(),
            head_only_indicator: r.get(7) == Some(&"H".to_string()),
            headers: match payload {
                Some(payload) => payload[0..headers_len].to_vec(),
                None => vec![],
            },
            body: match payload {
                Some(payload) => payload[headers_len..body_len].to_vec(),
                None => vec![],
            }
        })
    }
    pub fn marshal(&self) -> Vec<u8> {
        let response_compression = &self.response_compression.join(",");
        let headers_len = self.headers.len().to_string();
        let body_len = self.body.len().to_string();

        let mut parts: Vec<&str> = vec![
            "EWP",
            &self.version,
            &self.command,
            &self.compression,
            response_compression,
            &headers_len,
            &body_len
        ];

        if self.head_only_indicator {
            parts.push("H")
        }

        let req_line = parts.join(" ") + "\n";

        let mut rval = req_line.into_bytes();
        rval.extend(&self.headers);
        rval.extend(&self.body);

        rval
    }
}

#[derive(Clone,Debug)]
pub struct EWPResponse {
    pub code: u16,
    pub compression: String,
    pub headers: Vec<u8>,
    pub body: Vec<u8>,
}
impl EWPResponse {
    pub fn parse(res: &[u8]) -> Result<Self, std::io::Error> {
        let parts: Vec< &[u8] > = res.splitn(2, |chr| chr == &('\n' as u8) ).collect();
        let res_line: String = String::from_utf8(parts[0].to_vec()).map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let r: Vec<String> = res_line.splitn(4, |chr| chr == ' ').map(|s| s.to_string()).collect();
        let payload = parts.get(1);
        let code = r[0].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let headers_len = r[2].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let body_len = r[3].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;

        Ok(Self {
            code,
            compression: r[1].clone(),
            headers: match payload {
                Some(payload) => payload[0..headers_len].to_vec(),
                None => vec![],
            },
            body: match payload {
                Some(payload) => payload[headers_len..body_len].to_vec(),
                None => vec![],
            }
        })
    }
    pub fn marshal(&self) -> Vec<u8> {
        let mut rval = vec![];
        let req_line = format!("{} {} {} {}\n", self.code, self.compression, self.headers.len(), self.body.len());

        rval.extend(req_line.as_bytes());
        rval.extend(&self.headers);
        rval.extend(&self.body);

        rval
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mode = &args[1];
    let payload_len: usize = args[2].parse().expect("payload length is not an integer");
    let mut buffer = vec![0u8; payload_len];

    io::stdin().read_exact(&mut buffer).expect("could not read stdin");

    match mode.as_str() {
        "request" => {
            let req = EWPRequest::parse(&buffer).expect("parse request failed");
            let marshalled = req.marshal();
            let marshalled_str = unsafe { String::from_utf8_unchecked(marshalled) };
            print!("{}", marshalled_str);
        },
        "response" => {
            let res = EWPResponse::parse(&buffer).expect("parse response failed");
            let marshalled = res.marshal();
            let marshalled_str = unsafe { String::from_utf8_unchecked(marshalled) };
            print!("{}", marshalled_str);
        },
        _ => panic!("invalid serialization type"),
    };
}
