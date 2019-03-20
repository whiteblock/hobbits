package Hobbit;
use strict;
use warnings;

sub new {
    my ($class, $opts) = @_;
    $opts ||= {};
    my $self = { %$opts };
    bless($self, $class);
}

sub parse_request {
    my ($self, $req) = @_;
    my ($req_line, $payload) = ($req =~ /(.*?)\n(.*)/s);
    my @r = split(' ', $req_line);
    my $headers_len = int $r[5];
    my $body_len = int $r[6];
    my $headers = substr $payload, 0, $headers_len;
    my $body = substr $payload, $headers_len, $body_len;
    return {
        proto                => $r[0],
        version              => $r[1],
        command              => $r[2],
        compression          => $r[3],
        response_compression => [split(',', $r[4])],
        head_only_indicator  => (defined $r[7] ? $r[7] eq 'H' : 0),
        headers              => $headers,
        body                 => $body,
    }
}

sub parse_response {
    my ($self, $res) = @_;
    my ($res_line, $payload) = ($res =~ /(.*?)\n(.*)/s);
    my @r = split(' ', $res_line);
    my $headers_len = int $r[2];
    my $body_len = int $r[3];
    my $headers = substr $payload, 0, $headers_len;
    my $body = substr $payload, $headers_len, $body_len;
    return {
        code        => int $r[0],
        compression => $r[1],
        headers     => $headers,
        body        => $body
    }
}

sub marshal_request {
    my ($self, $req) = @_;
    my $res_compression = join(',', @{ $req->{response_compression} });
    my $head_only_indicator = $req->{head_only_indicator} ? ' H' : '';
    my $request_line = sprintf(
        "%s %s %s %s %s %d %d%s",
        $req->{proto},
        $req->{version},
        $req->{command},
        $req->{compression},
        $res_compression,
        length($req->{headers}),
        length($req->{body}),
        $head_only_indicator);
    my $r = sprintf("%s\n%s%s", $request_line, $req->{headers}, $req->{body});
    return $r;
}

sub marshal_response {
    my ($self, $res) = @_;
    my $out = sprintf('%s %s %d', $res->{code}, $res->{compression}, length($res->{headers}));
    if ($res->{body}) {
        $out .= sprintf(" %d", length($res->{body}));
    } else {
        $out .= " 0";
    }
    $out .= sprintf("\n%s%s", $res->{headers}, $res->{body});
    return $out;
}

1;

__END__

=head1 NAME

Hobbit - a parser for the Hobbit protocol

=head1 SYNOPSIS

    my $hobbit  = Hobbit->new();
    my $request = $hobbit->parse_request("EWP 0.1 PING none none 0 5\n12345");

=head1 DESCRIPTION

This is a Perl implementation of the Hobbit protocol which is
a lightweight, multiclient wire protocol for ETH2.0 communications.

=head1 API

=head2 new(%opts)

=head2 parse_request($request_string)

=head2 parse_response($response_string)

=head2 marshal_request($request_hashref)

=head2 marshal_response($response_hashref)

=head1 SEE ALSO

=over 4

=item https://github.com/Whiteblock/hobbits

=back

=head1 AUTHOR

John Beppu (john.beppu@gmail.com)

=cut
