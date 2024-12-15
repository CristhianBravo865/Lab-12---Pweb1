#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

# Conexión a la base de datos
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

# Obtener valores del formulario
my $store_id = $cgi->param('store_id');
my $book_id  = $cgi->param('book_id');

# Validar parámetros
if (!defined $store_id || $store_id !~ /^\d+$/ || !defined $book_id || $book_id !~ /^\d+$/) {
    print $cgi->header(-type => 'application/json', -charset => 'UTF-8');
    print encode_json({ success => 0, error => 'Parámetros inválidos. Asegúrese de enviar valores numéricos.' });
    exit;
}

# Verificar si la relación ya existe en inventario
my $relation_exists = $dbh->selectrow_array(
    "SELECT 1 FROM inventario WHERE tienda_id = ? AND libro_id = ?",
    undef, $store_id, $book_id
);

if ($relation_exists) {
    # Relación ya existe
    print $cgi->header(-type => 'application/json', -charset => 'UTF-8');
    print encode_json({ success => 0, error => 'La relación entre la tienda y el libro ya existe.' });
} else {
    # Crear la nueva relación
    eval {
        my $sth = $dbh->prepare("INSERT INTO inventario (tienda_id, libro_id) VALUES (?, ?)");
        $sth->execute($store_id, $book_id);
    };

    if ($@) {
        print $cgi->header(-type => 'application/json', -charset => 'UTF-8');
        print encode_json({ success => 0, error => "Error al insertar en inventario: $@" });
    } else {
        print $cgi->header(-type => 'application/json', -charset => 'UTF-8');
        print encode_json({ success => 1, message => 'Relación de inventario agregada correctamente.' });
    }
}

# Cerrar conexión
$dbh->disconnect();
