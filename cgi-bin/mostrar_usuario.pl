#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use JSON;
use DBI;

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
    PrintError       => 0,
    mysql_enable_utf8 => 1,
}) or die to_json({ error => "No se pudo conectar a la base de datos: $DBI::errstr" });

# Obtener el correo desde los parámetros
my $login_correo = $cgi->param('login_correo');
if (!$login_correo) {
    print to_json({ error => "Parámetro 'login_correo' es requerido" });
    exit;
}

# Preparar y ejecutar la consulta principal
my $sth = $dbh->prepare("SELECT id, login_correo, login_clave, nombre, tarjeta_id, tipo FROM usuario WHERE login_correo = ?");
$sth->execute($login_correo);

# Obtener resultados
if (my $user_data = $sth->fetchrow_hashref) {
    # Inicializar datos planos con información del usuario
    my %flat_data = %$user_data;

    # Si existe tarjeta_id, realizar una segunda consulta y fusionar los datos
    if ($user_data->{tarjeta_id}) {
        my $sth_card = $dbh->prepare("SELECT numero AS tarjeta_numero, tipo AS tarjeta_tipo, fecha_expiracion AS tarjeta_fecha_expiracion, cvv AS tarjeta_cvv FROM tarjeta WHERE id = ?");
        $sth_card->execute($user_data->{tarjeta_id});
        
        if (my $card_data = $sth_card->fetchrow_hashref) {
            %flat_data = (%flat_data, %$card_data); # Fusionar datos de tarjeta en el hash plano
        } else {
            $flat_data{tarjeta_error} = "Información de tarjeta no encontrada";
        }
        $sth_card->finish;
    }

    print to_json(\%flat_data, { utf8 => 1, pretty => 1 });  # Enviar datos como JSON plano
} else {
    print to_json({ error => "Usuario no encontrado: $login_correo" });
}

# Cerrar conexiones
$sth->finish;
$dbh->disconnect;
