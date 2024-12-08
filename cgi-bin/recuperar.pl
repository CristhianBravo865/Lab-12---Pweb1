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
print $cgi->header('application/json');

my $json_input = $cgi->param('POSTDATA');
my $datos = decode_json($json_input);

my $correo = $datos->{correo};
my $pregunta1 = $datos->{pregunta1};
my $pregunta2 = $datos->{pregunta2};
my $tipoUsuario = $datos->{tipoUsuario};

my %errors;

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password);

validate_data();

sub validate_data {
    if (length($correo) == 0) {
    #if(length($correo) == 0 || $correo !~ /^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$/) {
        $errors{correo} = "Ingrese un correo electrónico válido.";
    }

    if (length($pregunta1) == 0) {
        $errors{pregunta1} = "Ingrese la primera pregunta de seguridad.";
    }

    if (length($pregunta2) == 0) {
        $errors{pregunta2} = "Ingrese la segunda pregunta de seguridad.";
    }

    # Aquí puedes agregar más validaciones según tus requisitos

    # Verificar el tipo de usuario seleccionado
    unless ($tipoUsuario eq "vendedor" || $tipoUsuario eq "usuario") {
        $errors{tipoUsuario} = "Seleccione un tipo de usuario válido.";
    }
}

if (%errors) {
    my $response_data = {
        valido => 0,
        errors => \%errors
    };
    print encode_json($response_data);
} else {
    # Aquí puedes incluir la lógica para verificar los datos con el perfil deseado
    # Si los datos coinciden con el perfil, setea 'valido' a 1, de lo contrario, a 0
    my $valido = verificar_datos_con_perfil($correo, $pregunta1, $pregunta2, $tipoUsuario);

    my $response_data = {
        valido => $valido
    };
    print encode_json($response_data);
}

sub verificar_datos_con_perfil {
    my ($correo, $pregunta1, $pregunta2, $tipoUsuario) = @_;

    my $sql = "SELECT COUNT(*) FROM $tipoUsuario WHERE correo = ? AND pregunta1 = ? AND pregunta2 = ?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($correo, $pregunta1, $pregunta2);
    my ($count) = $sth->fetchrow_array();

    # Cerrar conexión a la base de datos
    $dbh->disconnect();

    # Si la cuenta existe, retornar 1, de lo contrario, retornar 0
    return $count > 0 ? 1 : 0;
}