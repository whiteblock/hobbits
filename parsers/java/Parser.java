import java.net.http.HttpResponse.BodySubscriber;

/**
 * Copyright Whiteblock, Inc. and others 2019
 * 
 * Licensed under MIT license.
 */
import java.util.Arrays;

/**
 * Example parser in Java for EWP.
 */
public final class Parser {

    public static final class Message {

        private final String protocol;
        private final String version;
        private final String command;
        private final String compression;
        private final String[] responseCompression;
        private final boolean headOnlyIndicator;
        private final String headers;
        private final String body;

        
        Message(String protocol,
          String version, 
          String command, 
          String compression, 
          String[] responseCompression, 
          boolean headOnlyIndicator, 
          String headers, 
          String body) {
              this.protocol = protocol;
              this.command = command;
              this.version = version;
              this.compression = compression;
              this.responseCompression = responseCompression;
              this.headOnlyIndicator = headOnlyIndicator;
              this.headers = headers;
              this.body = body;
        }

        public String toString() {
            return "Message{protocol=" + protocol + ",version=" + version + ",command=" + command + ",compression=" + compression + 
            ",responseCompression=" + Arrays.asList(responseCompression) + ",headOnlyIndicator=" + headOnlyIndicator + ",headers=" + headers + ",body=" + body + "}";
        }
    }

    /**
     * Parses a string into a EWP message
     * @param str the string to parse
     * @return the message
     * @throws IllegalArgumentException if the string doesn't match the EWP spec.
     */
    public static final Message parse(String str) {
        int newline = str.indexOf('\n');
        if (newline == -1) {
            throw new IllegalArgumentException("No request line found");
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
        return new Message(requestArguments[0], 
          requestArguments[1],
          requestArguments[2],
          requestArguments[3],
          requestArguments[4].split(","),
          headOnlyIndicator,
          headers,
          body);
    }

    public static void main(String[] args) {
        String toRead = "EWP 0.1 PING none none 0 5\n12345";
        System.out.println("Message to read " + toRead);
        Message msg = parse(toRead);
        System.out.println(msg.toString());
    }
}