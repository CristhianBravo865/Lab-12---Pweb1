#!/usr/bin/perl

use strict;
use CGI;
use CGI::Cookie;

my $cgi = CGI->new;

my $cookie = CGI::Cookie->new(
    -name    => "id_session",
    -value   => "",
    -expires => "-1d", 
);

print $cgi->header(-cookie => $cookie);