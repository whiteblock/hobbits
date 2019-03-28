import java.net.http.HttpResponse.BodySubscriber;
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
        private final String compression;
        private final String encoding;
        private final boolean headOnlyIndicator;
        private final String headers;
        private final String body;

        
        Request(String protocol,
          String version, 
          String command, 
          String compression, 
          String encoding, 
          boolean headOnlyIndicator, 
          String headers, 
          String body) {
              this.protocol = protocol;
              this.command = command;
              this.version = version;
              this.compression = compression;
              this.encoding = encoding;
              this.headOnlyIndicator = headOnlyIndicator;
              this.headers = headers;
              this.body = body;
        }

        public String toString() {
            StringBuilder builder = new StringBuilder();
            builder.append(protocol + " " +
             version + " " +
              command + " " +
               compression + " " + encoding);
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
            if (headOnlyIndicator) {
                builder.append(" H");
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
    public static final Request parseRequest(String str) {
        int newline = str.indexOf('\n');
        if (newline == -1) {
            throw new IllegalArgumentException("No new line found");
        }
        String reqLine = str.substring(0, newline);
        String[] requestArguments = reqLine.split(" ");
        if (requestArguments.length < 6) {
            throw new IllegalArgumentException("Not enough elements in request line");
        }
        int headerLength = 0;
        int bodyLength = 0;
        try {
          headerLength = Integer.parseInt(requestArguments[5]);
          bodyLength = Integer.parseInt(requestArguments[6]);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(e);
        }
        if (str.length() < newline + 1 + headerLength + bodyLength) {
            throw new IllegalArgumentException("Invalid length encoding");
        }
        boolean headOnlyIndicator = requestArguments.length == 8 && "H".equals(requestArguments[7]);
        String headers = str.substring(newline + 1, newline + 1 + headerLength);
        String body = null;
        if (!headOnlyIndicator) {
          body = str.substring(newline + 1 + headerLength, newline + 1 + headerLength + bodyLength);
        }
        return new Request(requestArguments[0], 
          requestArguments[1],
          requestArguments[2],
          requestArguments[3],
          requestArguments[4],
          headOnlyIndicator,
          headers,
          body);
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