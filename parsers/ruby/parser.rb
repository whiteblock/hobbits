class Request

  attr_reader :protocol, :version, :compression, :encoding, :headers, :body

  def initialize(protocol, version, compression, encoding, headers, body)
    @protocol = protocol
    @version = version
    @compression = compression
    @encoding = encoding
    #@head_only_indicator = head_only_indicator
    @headers = headers
    @body = body
  end

end

class Parser

  def self.parse_request(request)
    lines = request.split("\n")
    parts = lines[0].split(" ")
    protocol = parts[0]
    version = parts[1]
    compression = parts[3]
    encoding = parts[4]
    #head_only_indicator = " "
    headers = ""
    if parts[5].to_i > 0
      headers = lines[1][0..(parts[5].to_i-1)]
    end
    body = lines[1][parts[5].to_i..(parts[6].to_i-1)]

    Request.new(protocol, version, compression, encoding, headers, body)
  end

end
