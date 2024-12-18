#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

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
    PrintError       => 1,
    mysql_enable_utf8 => 1,
}) or die to_json({ error => "No se pudo conectar a la base de datos: $DBI::errstr" });

# Leer datos enviados en JSON
my $input = $cgi->param('POSTDATA');
my $data = decode_json($input);

my $id = $data->{id};
my $correo = $data->{correo};
my $clave = $data->{clave};
my $nombre = $data->{nombre};
my $tarjeta_id = $data->{tarjeta_id};

# Validar datos
if (!$id || !$correo || !$clave || !$nombre) {
    print to_json({ error => "Faltan datos obligatorios." });
    exit;
}

# Actualizar los datos en la base de datos
my $sth = $dbh->prepare("UPDATE usuario SET login_correo = ?, login_clave = ?, nombre = ?, tarjeta_id = ? WHERE id = ?");
my $result = $sth->execute($correo, $clave, $nombre, $tarjeta_id, $id);

if ($result) {
    print to_json({ success => "Datos actualizados correctamente." });
} else {
    print to_json({ error => "No se pudieron actualizar los datos." });
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;
