#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use File::Basename;
use File::Copy;

# Configuración de la base de datos
my $database   = "biblioteca";
my $hostname   = "bibliotecadb";
my $port       = 3306;
my $username   = "root";
my $password_db = "password";
my $dsn        = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Configuración del directorio de imágenes
my $upload_dir = "/var/www/html/images/";

# Inicializar CGI
my $cgi = CGI->new;

# Conexión a la base de datos
my $dbh = DBI->connect($dsn, $username, $password_db, {
    RaiseError       => 1,
    PrintError       => 1,
    mysql_enable_utf8 => 1,
}) or die "No se pudo conectar a la base de datos: $DBI::errstr\n";

# Configuración de la respuesta
print $cgi->header('application/json');

# Obtener parámetros del formulario
my $tienda_id   = $cgi->param('tienda_id');
my $nombre      = $cgi->param('nombre');
my $descripcion = $cgi->param('descripcion');
my $precio      = $cgi->param('precio');
my $stock       = $cgi->param('stock');
my $imagen_file = $cgi->upload('imagen'); # Archivo subido

# Validación de parámetros
unless ($tienda_id && $nombre && $descripcion && $precio && $stock && $imagen_file) {
    print '{"error": "Todos los campos son obligatorios"}';
    exit;
}

# Procesar el archivo de imagen
my $filename = basename($imagen_file);  # Obtener el nombre original del archivo
my $filepath = $upload_dir . $filename; # Ruta destino en el servidor

# Guardar la imagen en el servidor
open(my $out, '>', $filepath) or die "No se pudo guardar la imagen: $!";
binmode $out;
while (my $bytes = <$imagen_file>) {
    print $out $bytes;
}
close $out;

# Insertar los datos en la base de datos
eval {
    my $sth = $dbh->prepare("
        INSERT INTO libros (tienda_id, nombre, descripcion, imagen, precio, stock)
        VALUES (?, ?, ?, ?, ?, ?)
    ");
    $sth->execute($tienda_id, $nombre, $descripcion, $filename, $precio, $stock);
    $sth->finish;
};

if ($@) {
    print '{"error": "Error al guardar los datos en la base de datos"}';
} else {
    print '{"success": true, "message": "Libro agregado correctamente"}';
}

# Cerrar la conexión a la base de datos
$dbh->disconnect();
