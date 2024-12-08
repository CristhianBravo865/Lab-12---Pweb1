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
