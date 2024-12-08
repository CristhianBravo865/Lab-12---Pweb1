#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use CGI::Session;
use DBI;
use JSON;

my $cgi = CGI->new;
$cgi->charset("UTF-8");

my $session_cookie = $cgi->cookie("id_session") || '';
my $session = CGI::Session->new(undef, $session_cookie, {Directory => '/tmp'});

my $user_id = $session->param("session_id");

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 });

if (!$dbh) {
    print $cgi->header("text/html");
    print "<p>Error de conexión a la base de datos</p>";
    exit;
}

my $sth = $dbh->prepare("SELECT nombre, imagen, precio FROM producto WHERE vendedor_id = ?");
$sth->execute($user_id);

my @products;
while (my $row = $sth->fetchrow_hashref) {
    push @products, {
        nombre => $row->{nombre},
        imagen => $row->{imagen},
        precio => $row->{precio},
    };
}

print $cgi->header("application/json");
print encode_json(\@products);

$dbh->disconnect();