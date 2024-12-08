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

my $json_input = $cgi->param('POSTDATA') || '';
my $input_data = decode_json($json_input);
my $nombre_producto = $input_data->{nombre} || '';

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 });

if (!$dbh) {
    print $cgi->header("text/html");
    print "<p>Error de conexión a la base de datos</p>";
    exit;
}

my $query = "DELETE FROM producto WHERE vendedor_id = ? AND nombre = ?";
my $sth = $dbh->prepare($query);
$sth->execute($user_id, $nombre_producto);

print $cgi->header("application/json");
print encode_json({ success => 1, productoEliminado => $nombre_producto });

$dbh->disconnect();
