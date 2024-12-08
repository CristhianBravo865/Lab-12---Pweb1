#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

# Configuración de conexión
my $database = "biblioteca";
my $hostname = "bibliotecadb";              
my $port     = 3306;   
my $username = "root";  
my $password = "rootpassword";   

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos con manejo adecuado de errores
my $dbh = DBI->connect($dsn, $username, $password, {
    RaiseError       => 1,        # Lanza excepciones si ocurre un error
    PrintError       => 1,        # Imprime los errores por consola
    mysql_enable_utf8 => 1,       # Habilita UTF-8
}) or die "No se pudo conectar a la base de datos: $DBI::errstr\n";

# Si la conexión es exitosa, muestra el tipo de contenido
print "Content-type: text/html\n\n";  

# Aquí puedes realizar las consultas o manipulaciones de la base de datos, por ejemplo:
# my $sth = $dbh->prepare("SELECT * FROM tabla");
# $sth->execute();

# Si realizas una consulta o algún procesamiento, asegúrate de manejar errores si algo falla.
# Si necesitas mostrar resultados, por ejemplo:
# while (my $row = $sth->fetchrow_hashref) {
#     print "$row->{columna}\n";
# }

# Cerrar la conexión correctamente
$dbh->disconnect();
