#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

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
}) or die "No se pudo conectar a la base de datos: $DBI::errstr\n";

# Inicializar CGI
my $cgi = CGI->new;

# Obtener datos del formulario
my $correo = $cgi->param('login_usuario');
my $password = $cgi->param('password');

# Preparar consulta para verificar el usuario
my $sql = "SELECT nombre, login_clave FROM usuario WHERE login_correo = ?";
my $sth = $dbh->prepare($sql);
$sth->execute($correo);

# Verificar si el usuario existe
my ($nombre, $clave_almacenada) = $sth->fetchrow_array();
if ($clave_almacenada && $clave_almacenada eq $password) {
    # Si las credenciales son correctas, redirigir al índice con el nombre
    print $cgi->header(-location => "/index.html?nombre=$nombre");
} else {
    # Si las credenciales son incorrectas, redirigir al login con error
    print $cgi->header(-location => "/login.html?error=1");
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;
