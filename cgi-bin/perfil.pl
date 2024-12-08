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
my $dbh = DBI->connect($dsn, $db_user, $db_password, {RaiseError => 1, PrintError => 1})
  or die "Error de conexión: $DBI::errstr";

my $query;
$query = "SELECT nombreC, dni, celular, tipo_usuario, nombre_usuario, correo, tarjeta.numero FROM $user_type  JOIN tarjeta ON $user_type.tarjeta_id = tarjeta.id WHERE $user_type.ID = ?";

my $sth = $dbh->prepare($query);
$sth->execute($user_id);

my @datosUsuario = $sth->fetchrow_array;
$datosUsuario[6] =~ s/(\d{4})(?=\d{4})/$1-/g; 
print "Content-type: application/json\n\n";

my $json_data = encode_json(\@datosUsuario);
print $json_data;

$dbh->disconnect();