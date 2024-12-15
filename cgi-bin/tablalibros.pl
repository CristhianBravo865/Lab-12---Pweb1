#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

# Configuración de conexión a la base de datos
my $database = "biblioteca";
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
print $cgi->header(-type => "application/json", -charset => "UTF-8");

# Consultar los libros
my $sth = $dbh->prepare("SELECT id, nombre, descripcion, imagen, precio FROM libros");
$sth->execute();

# Convertir los resultados a JSON
my @libros;
while (my $row = $sth->fetchrow_hashref) {
    push @libros, $row;
}

print to_json(\@libros);

# Cerrar conexión
$dbh->disconnect();
