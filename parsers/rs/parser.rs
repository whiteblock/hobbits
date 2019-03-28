use std::env;
use std::io::{self, Read};

#[derive(Clone,Debug)]
pub struct EWPRequest {
    pub version: String,
    pub command: String,
    pub headers: Vec<u8>,
    pub body: Vec<u8>
}


impl EWPRequest {
    pub fn parse(req: &[u8]) -> Result<Self, std::io::Error> {
        let req_line_end_idx = req.iter().position(|b| *b == ('\n' as u8))
            .ok_or_else(||
                std::io::Error::new(std::io::ErrorKind::Other, "request newline terminator missing")
            )
        ?;
        let req_line_raw = &req[..req_line_end_idx];
        let payload = &req[(req_line_end_idx + 1)..];
        let req_line: String = String::from_utf8(req_line_raw.to_vec()).map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;

        let r: Vec<String> = req_line.splitn(8, |chr| chr == ' ').map(|s| s.to_string()).collect();
        assert!(&r[0] == "EWP");
        assert!(&r[1] == "0.2");
        let headers_len: usize = r[3].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;
        let body_len: usize = r[4].parse().map_err(|err| std::io::Error::new(std::io::ErrorKind::Other, err))?;

        Ok(Self {
            version: "0.2".to_string(),
            command: r[2].clone(),
            headers: payload[0..headers_len].to_vec(),
            body: payload[headers_len..(headers_len + body_len)].to_vec(),
        })
    }
    pub fn marshal(&self) -> Vec<u8> {
        let headers_len = self.headers.len().to_string();
        let body_len = self.body.len().to_string();

        let mut parts: Vec<&str> = vec![
            "EWP",
            &self.version,
            &self.command,
            &headers_len,
            &body_len
        ];

        let req_line = parts.join(" ") + "\n";

        let mut rval = req_line.into_bytes();
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
        _ => panic!("invalid serialization type"),
    };
}
