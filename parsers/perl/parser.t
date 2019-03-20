#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 13;

require_ok('./Hobbit.pm');

my $hobbit = Hobbit->new();
ok($hobbit->isa('Hobbit'), "Hobbit->new() returned a Hobbit parser instance");

my $request = $hobbit->parse_request("EWP 0.1 PING none none 0 5\n12345");
is($request->{proto}, 'EWP', "proto should be 'EWP'");
is($request->{version}, '0.1', "version should be '0.1'");
is($request->{command}, 'PING', "command should be 'PING'");
is($request->{compression}, 'none', "compression should be 'none'");
ok(!$request->{head_only_indicator}, "head_only_indicator should be false");
is($request->{headers}, '', "headers should be an empty string");
is($request->{body}, '12345', "body should be '12345'");

my $response = $hobbit->parse_response("200 none 4 4\na=16body");
is($response->{code}, 200, "code should be 200");
is($response->{compression}, 'none', "compression should be 'none'");
is($response->{headers}, "a=16", "headers should be 'a=16'");
is($response->{body}, "body", "body should be 'body'");

