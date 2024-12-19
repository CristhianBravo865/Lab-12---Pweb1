#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use JSON;
use DBI;

# Configuración CGI
my $cgi = CGI->new;
print $cgi->header('application/json; charset=UTF-8');

# Conexión a la base de datos
my $database = "usuarios_info";
my $hostname = "bibliotecadb";
my $port     = 3306;
my $username = "root";
my $password_db = "password";

my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, $username, $password_db, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
}) or die to_json({ error => "No se pudo conectar a la base de datos: $DBI::errstr" });

# Obtener el correo desde los parámetros
my $login_correo = $cgi->param('login_correo');
if (!$login_correo) {
    print to_json({ error => "Parámetro 'login_correo' es requerido" });
    exit;
}

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare("SELECT id, login_correo, login_clave, nombre, tarjeta_id, tipo FROM usuario WHERE login_correo = ?");
$sth->execute($login_correo);

# Obtener resultados
if (my $row = $sth->fetchrow_hashref) {
    print to_json($row, { utf8 => 1, pretty => 1 });  # Enviar datos como JSON
} else {
    print to_json({ error => "Usuario no encontrado.".$login_correo });
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;
