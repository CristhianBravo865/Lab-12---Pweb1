#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

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
print $cgi->header(-type => "text/html", -charset => "UTF-8");

# Obtener los datos del formulario
my $usuario = $cgi->param('login_usuario');
my $password = $cgi->param('password');

# Consultar a la base de datos para obtener nombre y tipo
my $query = "SELECT nombre, tipo FROM usuario WHERE login_correo = ? AND login_clave = ?";
my $sth = $dbh->prepare($query);
$sth->execute($usuario, $password);

if (my $row = $sth->fetchrow_hashref) {
    # Usuario encontrado, guardar en localStorage y redirigir
    print <<HTML;
        <html>
        <head>
            <script>
                // Guardar datos en localStorage
                localStorage.setItem('nombre_usuario', '$row->{nombre}');
                localStorage.setItem('login_correo', '$usuario');
                localStorage.setItem('tipo_usuario', '$row->{tipo}');
                
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
