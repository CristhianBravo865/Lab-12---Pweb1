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
print $cgi->header(-type => "text/html", -charset => "UTF-8");

# Obtener los datos del formulario
my $usuario = $cgi->param('login_usuario');
my $password = $cgi->param('password');

# Consultar a la base de datos
my $query = "SELECT nombre FROM usuario WHERE login_correo = ? AND login_clave = ?";
my $sth = $dbh->prepare($query);
$sth->execute($usuario, $password);

if (my $row = $sth->fetchrow_hashref) {
    # Usuario encontrado, redirigir con el nombre del usuario
    print <<HTML;
        <html>
        <head>
            <script>
                localStorage.setItem('nombre_usuario', '$row->{nombre}');
                window.location.href = '../index.html';
            </script>
        </head>
        <body>
        </body>
        </html>
HTML
} else {
    # Usuario o contraseña incorrectos
    print <<HTML;
    <html>
    <body>
        <script>
            window.location.href = '../login.html?error=1';
        </script>
    </body>
    </html>
HTML
}
