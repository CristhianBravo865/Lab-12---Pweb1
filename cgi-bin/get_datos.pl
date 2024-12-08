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
my $user_type = $session->param("session_type");

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";                               
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 0 })
    or die "Error de conexión: $DBI::errstr";

my $query;
my $query = "
    SELECT u.login_usuario, t.saldo
    FROM $user_type u
    LEFT JOIN tarjeta t ON u.tarjeta_id = t.id
    WHERE u.ID = ?;
";
 
my $sth = $dbh->prepare($query);
$sth->execute($user_id);

my @datos = $sth->fetchrow_array;

my $credito_s = $datos[1] // '';
$credito_s = "$credito_s";
my $perfil_s = $datos[0] // '';
$perfil_s = "$perfil_s";

print $cgi->header("application/json");

my $json_data = encode_json({ credito => $credito_s, perfil => $perfil_s });
print $json_data;

$dbh->disconnect();
