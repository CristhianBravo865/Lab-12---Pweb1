#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use CGI::Cookie;

# Configuración de conexión a la base de datos
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

# Obtener los datos del formulario
my $usuario = $cgi->param('login_usuario');
my $password = $cgi->param('password');

# Consultar a la base de datos para obtener nombre y tipo
my $query = "SELECT nombre, tipo FROM usuario WHERE login_correo = ? AND login_clave = ?";
my $sth = $dbh->prepare($query);
$sth->execute($usuario, $password);

if (my $row = $sth->fetchrow_hashref) {
    # Usuario encontrado, crear cookies
    my $cookie_nombre_usuario = CGI::Cookie->new(-name => 'nombre_usuario', -value => $row->{nombre}, -expires => '+1h');
    my $cookie_login_correo = CGI::Cookie->new(-name => 'login_correo', -value => $usuario, -expires => '+1h');
    my $cookie_tipo_usuario = CGI::Cookie->new(-name => 'tipo_usuario', -value => $row->{tipo}, -expires => '+1h');

    # Guardar cookies y redirigir
    print $cgi->header(-type => 'text/html', -cookie => [$cookie_nombre_usuario, $cookie_login_correo, $cookie_tipo_usuario]);
    print <<HTML;
        <html>
        <head>
            <script>
                // Redirigir al inicio
                window.location.href = '../index.html';
            </script>
        </head>
        <body>
        </body>
        </html>
HTML
} else {
    # Usuario o contraseña incorrectos
    print $cgi->header(-type => 'text/html');
    print <<HTML;
    <html>
    <body>
        <script>
            alert('Usuario o contraseña incorrectos');
            window.location.href = '../login.html?error=1';
        </script>
    </body>
    </html>
HTML
}
