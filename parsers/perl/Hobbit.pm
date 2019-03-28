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
        headers              => $headers,
        body                 => $body,
    }
}

sub marshal_request {
    my ($self, $req) = @_;
    my $request_line = sprintf(
        "%s %s %s %s %s %d %d%s",
        $req->{proto},
        $req->{version},
        $req->{command},
        length($req->{headers}),
        length($req->{body}));
    my $r = sprintf("%s\n%s%s", $request_line, $req->{headers}, $req->{body});
    return $r;
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

=head2 marshal_request($request_hashref)

=head1 SEE ALSO

=over 4

=item https://github.com/Whiteblock/hobbits

=back

=head1 AUTHOR

John Beppu (john.beppu@gmail.com)

=cut
