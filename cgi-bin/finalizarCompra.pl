#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

# Configuración de conexión a la base de datos
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
}) or die "No se pudo conectar a la base de datos: $DBI::errstr\n";

# Crear el objeto CGI para manejar la solicitud
my $cgi = CGI->new;

# Configurar encabezados de respuesta
print $cgi->header('application/json');

# Obtener el nombre de usuario de la solicitud
my $usuario = $cgi->param('usuario');
if (!$usuario) {
    print '{"error":"Usuario no proporcionado"}';
    exit;
}

# Buscar la ID del usuario en la tabla usuario
my $sth = $dbh->prepare("SELECT id FROM usuario WHERE nombre = ?");
$sth->execute($usuario);
my ($user_id) = $sth->fetchrow_array;

if (!$user_id) {
    print '{"error":"Usuario no encontrado"}';
    exit;
}

# Buscar la tarjeta asociada al usuario
$sth = $dbh->prepare("SELECT numero FROM tarjeta WHERE usuario_id = ?");
$sth->execute($user_id);
my ($numero) = $sth->fetchrow_array;

# Verificar si se encontró una tarjeta
if ($numero) {
    # Devolver los últimos 3 dígitos de la tarjeta
    my $censurado = substr($numero, -3);
    print qq({"tarjeta":"$censurado"});
} else {
    # No hay tarjeta asociada
    print '{"tarjeta":null}';
}

# Cerrar la conexión con la base de datos
$dbh->disconnect;
