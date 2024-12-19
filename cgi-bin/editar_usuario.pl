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

# Datos del usuario
my $id = $data->{id};
my $correo = $data->{correo};
my $clave = $data->{clave};
my $nombre = $data->{nombre};

# Datos de la tarjeta
my $tarjeta_id = $data->{tarjeta_id};
my $numero_tarjeta = $data->{numero_tarjeta};
my $tipo_tarjeta = $data->{tipo_tarjeta};
my $fecha_expiracion = $data->{fecha_expiracion};
my $cvv = $data->{cvv};

# Validar datos
if (!$id || !$correo || !$clave || !$nombre) {
    print to_json({ error => "Faltan datos obligatorios del usuario." });
    exit;
}

# Actualizar los datos del usuario
my $sth = $dbh->prepare("UPDATE usuario SET login_correo = ?, login_clave = ?, nombre = ?, tarjeta_id = ? WHERE id = ?");
my $result_usuario = $sth->execute($correo, $clave, $nombre, $tarjeta_id, $id);

# Actualizar o insertar tarjeta
if ($tarjeta_id) {
    # Verificar si la tarjeta ya existe
    my $sth_check = $dbh->prepare("SELECT id FROM tarjeta WHERE id = ?");
    $sth_check->execute($tarjeta_id);
    if ($sth_check->fetchrow_array) {
        # Actualizar tarjeta existente
        my $sth_update_tarjeta = $dbh->prepare("UPDATE tarjeta SET numero = ?, tipo = ?, fecha_expiracion = ?, cvv = ? WHERE id = ?");
        $sth_update_tarjeta->execute($numero_tarjeta, $tipo_tarjeta, $fecha_expiracion, $cvv, $tarjeta_id);
    } else {
        # Insertar nueva tarjeta
        my $sth_insert_tarjeta = $dbh->prepare("INSERT INTO tarjeta (numero, tipo, fecha_expiracion, cvv, usuario_id) VALUES (?, ?, ?, ?, ?)");
        $sth_insert_tarjeta->execute($numero_tarjeta, $tipo_tarjeta, $fecha_expiracion, $cvv, $id);
    }
} else {
    # Crear una nueva tarjeta si no existe tarjeta_id
    my $sth_insert_tarjeta = $dbh->prepare("INSERT INTO tarjeta (numero, tipo, fecha_expiracion, cvv, usuario_id) VALUES (?, ?, ?, ?, ?)");
    $sth_insert_tarjeta->execute($numero_tarjeta, $tipo_tarjeta, $fecha_expiracion, $cvv, $id);
}

# Responder con éxito o error
if ($result_usuario) {
    print to_json({ success => "Datos del usuario y tarjeta actualizados correctamente." });
} else {
    print to_json({ error => "No se pudieron actualizar los datos del usuario." });
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;
