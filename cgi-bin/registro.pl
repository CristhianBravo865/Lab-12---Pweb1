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

# Recuperar datos del formulario
my $nombre = $cgi->param('nombreC') || '';
my $usuario = $cgi->param('nameSesionUsuario') || '';
my $password = $cgi->param('password') || '';
my $password2 = $cgi->param('password2') || '';

# Validación de datos
my @errores;
push @errores, "El nombre completo es obligatorio." unless $nombre =~ /\S+/;
push @errores, "El usuario es obligatorio." unless $usuario =~ /\S+/;
push @errores, "La contraseña es obligatoria." unless $password;
push @errores, "Las contraseñas no coinciden." if $password ne $password2;

# Si hay errores, mostrarlos
if (@errores) {
    print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
    print "<!DOCTYPE html>";
    print "<html><head><title>Errores de Registro</title>";
    print "<link rel='stylesheet' href='../css/RegistroStyle.css'></head><body>";
    print "<div class='perfil'>";
    print "<div id='error-container' class='error-container'>";
    print "<p>Por favor corrige los siguientes errores:</p><ul>";
    print "<li>$_</li>" for @errores;
    print "</ul></div>";
    print "<a href='../registro.html' class='inicio'>Volver al formulario</a>";
    print "</div></body></html>";
    exit;
}

# Verificar si el usuario ya existe
my $sth_check = $dbh->prepare("SELECT COUNT(*) FROM usuario WHERE login_correo = ?");
$sth_check->execute($usuario);
my ($existe) = $sth_check->fetchrow_array;
$sth_check->finish;

if ($existe) {
    print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
    print "<!DOCTYPE html>";
    print "<html><head><title>Error de Registro</title>";
    print "<link rel='stylesheet' href='../css/RegistroStyle.css'></head><body>";
    print "<div class='perfil'>";
    print "<div id='error-container' class='error-container'>";
    print "<p>El correo ya está registrado. Por favor utiliza otro correo.</p>";
    print "</div>";
    print "<a href='../registro.html' class='inicio'>Volver al formulario</a>";
    print "</div></body></html>";
    exit;
}

# Insertar datos en la tabla usuario
eval {
    my $sth = $dbh->prepare("INSERT INTO usuario (login_correo, login_clave, nombre, tarjeta_id) VALUES (?, ?, ?, NULL)");
    $sth->execute($usuario, $password, $nombre);
    $sth->finish;
};
if ($@) {
    print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
    print "<!DOCTYPE html>";
    print "<html><head><title>Error de Registro</title>";
    print "<link rel='stylesheet' href='../css/RegistroStyle.css'></head><body>";
    print "<div class='perfil'>";
    print "<div id='error-container' class='error-container'>";
    print "<p>Ocurrió un error al registrar al usuario: $@</p>";
    print "</div>";
    print "<a href='../registro.html' class='inicio'>Volver al formulario</a>";
    print "</div></body></html>";
    exit;
}

# Cerrar conexión
$dbh->disconnect;

# Redirigir a página de éxito
print $cgi->redirect('/success.html');
