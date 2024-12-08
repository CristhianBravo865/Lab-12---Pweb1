#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;
use DateTime;

my $cgi = CGI->new;
$cgi->charset("UTF-8");

my $nombreC = $cgi->param("nombreC");
my $dni = $cgi->param("dni");
my $celular = $cgi->param("celular");
my $nameSesionUsuario = $cgi->param("nameSesionUsuario");
my $password = $cgi->param("password");
my $password2 = $cgi->param("password2");
my $tipoUsuario = $cgi->param("tipoUsuario");
my $nombreUsuario = $cgi->param("usuario");
my $correo = $cgi->param("correo");
my $numero_tarjeta = $cgi->param("numero_tarjeta");
my $fecha_caducidad_tarjeta = $cgi->param("fecha_caducidad_tarjeta");
my $codigo = $cgi->param("codigo");
my $pregunta1 = $cgi->param("pregunta1");
my $pregunta2 = $cgi->param("pregunta2");

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password);

my %errors;

if (!$nombreC || length($nombreC) == 0 || length($nombreC) > 30) {
    $errors{nombreC} = "Nombre invalido.";
}

if (!$dni || length($dni) == 0 || length($dni) != 8) {
    $errors{dni} = "DNI invalido.";
}

if (!$celular || length($celular) == 0 || length($celular) != 9) {
    $errors{celular} = "Número de celular invalido.";
}

if (!$nameSesionUsuario || length($nameSesionUsuario) == 0 || length($nameSesionUsuario) > 30) {

    $errors{nameSesionUsuario} = "Nombre de usuario de inicio de sesión invalido.";
}

if (!$password || length($password) == 0 || length($password) > 30) {
    $errors{password} = "Clave invalida.";
}

if ($password ne $password2) {
    $errors{password2} = "Las claves no coinciden.";
}

if (!$tipoUsuario || ($tipoUsuario ne "usuario" && $tipoUsuario ne "vendedor")) {
    $errors{tipoUsuario} = "Tipo de usuario invalido.";
}

if (!$nombreUsuario || length($nombreUsuario) == 0 || length($nombreUsuario) > 10) {
    $errors{nombreUsuario} = "Nombre de usuario invalido.";
}

if (!$correo || length($correo) == 0 || length($correo) > 50 || $correo !~ /\S+@\S+\.\S+/) {
    $errors{correo} = "Correo invalido.";
}

    #consulta que seleccione un elemento de la tabla $tipo_usuario 
if (!$numero_tarjeta || length($numero_tarjeta) == 0 || length($numero_tarjeta) > 19) {
    $errors{numero_tarjeta} = "Número de tarjeta invalido.";
}
if (!$pregunta1 || length($pregunta1) == 0 || length($pregunta1) > 15) {
    $errors{pregunta1} = "Respuesta 1 invalida.";
}
if (!$pregunta2 || length($pregunta2) == 0 || length($pregunta2) > 15) {
    $errors{pregunta2} = "Respuesta 2 invalida.";
}

#my $card_expire_time;
#if ($fecha_caducidad_tarjeta && $fecha_caducidad_tarjeta =~ /^(\d{4})-(\d{2})-(\d{2})$/) {
#    $card_expire_time = DateTime->new(year => $1, month => $2, day => $3);
#}

#if (!$card_expire_time || DateTime->now > $card_expire_time) {
#    $errors{fecha_caducidad_tarjeta} = "Fecha de expiración de tarjeta invalida.";
#}

if (!$codigo || length($codigo) != 3) {
    $errors{codigo} = "Código de seguridad invalido.";
}

register();

sub register {

    if (%errors == 0) {
        
        my $sth = $dbh->prepare("INSERT INTO tarjeta (`numero`, `caducidad`, `codigo`, `saldo`) VALUES ('$numero_tarjeta', '$fecha_caducidad_tarjeta', '$codigo', '500')");
        $sth->execute;

        $sth = $dbh->prepare("SELECT LAST_INSERT_ID()");
        $sth->execute;
        my @card_row = $sth->fetchrow_array;
        my $card_id = $card_row[0];

        $sth = $dbh->prepare("INSERT INTO $tipoUsuario (`login_usuario`, `login_clave`, `nombreC`,`dni`, `celular`, `tipo_usuario`, `nombre_usuario`, `correo`, `tarjeta_id`, `pregunta1`, `pregunta2`) 
        VALUES ('$nameSesionUsuario', '$password', '$nombreC', '$dni', '$celular', '$tipoUsuario', '$nombreUsuario', '$correo', '$card_id', '$pregunta1', '$pregunta2')");
        $sth->execute;
        print $cgi->redirect("http://localhost/UNSASHOP/index.html");
        return;
    }
    print_errors();
}

sub print_errors {
    print "<errors>\n";
    for my $key (keys %errors) {
        print <<XML;
        <error>
            <element>$key</element>
            <message>$errors{$key}</message>
        </error>
XML
    }
    print "</errors>\n";
}
