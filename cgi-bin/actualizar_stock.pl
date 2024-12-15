#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use JSON;
use DBI;

# Configuración de la base de datos
my $database    = "biblioteca";
my $hostname    = "bibliotecadb";
my $port        = 3306;
my $username    = "root";
my $password_db = "password";

my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, $username, $password_db, {
    RaiseError       => 1,
    PrintError       => 1,
    mysql_enable_utf8 => 1,
}) or die "No se pudo conectar a la base de datos: $DBI::errstr\n";

# Inicializar CGI
my $cgi = CGI->new;

# Leer el cuerpo del POST y decodificar el JSON
my $json_text = $cgi->param('POSTDATA');
my $input_data = decode_json($json_text);

# Validar parámetros requeridos
my $inventario_id = $input_data->{inventario_id};
my $stock         = $input_data->{stock};

if (!defined $inventario_id || !defined $stock || $stock !~ /^\d+$/) {
    print $cgi->header(-type => 'application/json', -charset => 'UTF-8', -status => '400 Bad Request');
    print encode_json({ success => 0, error => 'Datos inválidos o incompletos.' });
    exit;
}

# Actualizar el stock en la base de datos
eval {
    my $sth = $dbh->prepare("UPDATE inventario SET stock = ? WHERE inventario_id = ?");
    $sth->execute($stock, $inventario_id);

    if ($sth->rows > 0) {
        # Éxito: stock actualizado
        print $cgi->header(-type => 'application/json', -charset => 'UTF-8');
        print encode_json({ success => 1, message => 'Stock actualizado correctamente.' });
    } else {
        # Error: ID no encontrado
        print $cgi->header(-type => 'application/json', -charset => 'UTF-8', -status => '404 Not Found');
        print encode_json({ success => 0, error => 'No se encontró el inventario con el ID proporcionado.' });
    }
};

if ($@) {
    # Manejar errores en la ejecución de la consulta
    print $cgi->header(-type => 'application/json', -charset => 'UTF-8', -status => '500 Internal Server Error');
    print encode_json({ success => 0, error => "Error al actualizar el stock: $@" });
}

# Cerrar conexión
$dbh->disconnect();
