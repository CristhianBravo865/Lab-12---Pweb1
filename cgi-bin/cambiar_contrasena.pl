#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;
use JSON;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
print $cgi->header("application/json");

my $json_input = $cgi->param('POSTDATA');
my $datos = decode_json($json_input);

my $correo = $datos->{correo};
my $nueva_contrasena = $datos->{nuevaContrasena};
my $tipoUsuario = $datos->{tipoUsuario};

my %errors;

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password);

update_password();

sub update_password {

    # Validar la nueva contraseña
    #if (length($nueva_contrasena) < 8) {
    #    $errors{nuevaContraseña} = "La contraseña debe tener al menos 8 caracteres.";
    #}

    if (%errors) {
        my $response_data = {
            success => 0,
            errors => \%errors
        };
        print encode_json($response_data);
        return;
    }

    my $sql = "UPDATE $tipoUsuario SET login_clave = ? WHERE correo = ?";
    my $sth = $dbh->prepare($sql);
    my $result = $sth->execute($nueva_contrasena, $correo);

    if ($result) {
        my $response_data = {
            success => 1
        };
        print encode_json($response_data);
    } else {
        $errors{database} = "Error al actualizar la contraseña en la base de datos.";
        my $response_data = {
            success => 0,
            errors => \%errors
        };
        print encode_json($response_data);
    }

    $dbh->disconnect();
}