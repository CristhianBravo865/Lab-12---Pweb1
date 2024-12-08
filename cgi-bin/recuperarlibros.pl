#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use CGI qw(:standard);
use JSON;

# Configuración de conexión
my $database = "biblioteca";
my $hostname = "bibliotecadb";              
my $port     = 3306;   
my $username = "root";  
my $password = "password";   

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos con manejo adecuado de errores
my $dbh = DBI->connect($dsn, $username, $password, {
    RaiseError       => 1,        
    PrintError       => 1,        
    mysql_enable_utf8 => 1,       
}) or die "No se pudo conectar a la base de datos: $DBI::errstr\n";

# Preparar y ejecutar la consulta para obtener los libros
my $sth = $dbh->prepare("SELECT nombre, imagen, precio FROM libros");
$sth->execute();

# Recoger los resultados
my @libros;
while (my $row = $sth->fetchrow_hashref) {
    push @libros, {
        nombre => $row->{nombre},
        imagen => $row->{imagen},
        precio => $row->{precio},
    };
}

# Convertir los resultados a formato JSON
print "Content-type: application/json\n\n";
print to_json(\@libros);

# Cerrar la conexión correctamente
$dbh->disconnect();
