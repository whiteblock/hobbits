#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 7;

require_ok('./Hobbit.pm');

my $hobbit = Hobbit->new();
ok($hobbit->isa('Hobbit'), "Hobbit->new() returned a Hobbit parser instance");

my $request = $hobbit->parse_request("EWP 0.2 PING 0 5\n12345");
is($request->{proto}, 'EWP', "proto should be 'EWP'");
is($request->{version}, '0.2', "version should be '0.2'");
is($request->{command}, 'PING', "command should be 'PING'");
is($request->{headers}, '', "headers should be an empty string");
is($request->{body}, '12345', "body should be '12345'");

