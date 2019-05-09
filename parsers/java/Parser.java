//import java.net.http.HttpResponse.BodySubscriber;
import java.nio.charset.StandardCharsets;
/**
 * Copyright Whiteblock, Inc. and others 2019
 * 
 * Licensed under MIT license.
 */
import java.util.Arrays;
import java.io.IOException;

/**
 * Example parser in Java for EWP.
 */
public final class Parser {

    public static final class Request {

        private final String protocol;
        private final String version;
        private final String command;
        private final String headers;
        private final String body;

        
        Request(String protocol,
          String version, 
          String command, 
          String headers, 
          String body) {
              this.protocol = protocol;
              this.command = command;
              this.version = version;
              this.headers = headers;
              this.body = body;
        }

        public String toString() {
            StringBuilder builder = new StringBuilder();
            builder.append(protocol + " " +
             version + " " +
              command);
            if (headers == null) {
                builder.append(" 0");
            } else {
                builder.append(" ").append(headers.length());
            }
            if (body == null) {
                builder.append(" 0");
            } else {
                builder.append(" ").append(body.length());
            }
            builder.append("\n");
            if (headers != null) {
                builder.append(headers);
            }
            if (body != null) {
                builder.append(body);
            }
            return builder.toString();
        }
    }

    /**
     * Parses a string into a EWP request
     * @param str the string to parse
     * @return the request
     * @throws IllegalArgumentException if the string doesn't match the EWP spec.
     */
    public static Request parseRequest(String str) {
        final int newlineIdx = str.indexOf('\n');
        if (newlineIdx < 0) {
            throw new IllegalArgumentException("No new line found");
        }
        String reqLine = str.substring(0, newlineIdx);
        String[] requestArguments = reqLine.split(" ");
        if (requestArguments.length < 5) {
            throw new IllegalArgumentException("Not enough elements in request line");
        }
        final int startHeaders = newlineIdx + 1;
        final int endHeaders;
        final int endBody;
        try {
            int headerLength = Integer.parseUnsignedInt(requestArguments[3]);
            int bodyLength = Integer.parseUnsignedInt(requestArguments[4]);
            endHeaders = startHeaders + headerLength;
            endBody = endHeaders + bodyLength;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(e);
        }
        if (str.length() < endBody) {
            throw new IllegalArgumentException("Invalid length encoding");
        }
        return new Request(
                requestArguments[0],
                requestArguments[1],
                requestArguments[2],
                str.substring(startHeaders, endHeaders), // headers
                str.substring(endHeaders, endBody) // body
        );
    }

    public static void main(String[] args) throws IOException {
        String reqres = args[0];
        int length = Integer.parseInt(args[1]);
        byte[] input = new byte[length];
        System.in.read(input, 0, length);
        String toRead = new String(input, StandardCharsets.UTF_8);
        if ("request".equals(reqres)) {
            Request msg = parseRequest(toRead);
            System.out.print(msg.toString());
        } else {
            throw new IllegalArgumentException("invalid request response given " + reqres);
        }
    }
}