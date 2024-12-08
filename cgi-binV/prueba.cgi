use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $user = $cgi->param("login_usuario");
my $password = $cgi->param("password");
my $type = $cgi->param("tipo_usuario_login");
my $session_time = 86400;

print "Content-type: text/html\n\n";

my $db_user     = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn         = "dbi:mysql:database=unsashop;host=127.0.0.1";

my $dbh = DBI->connect($dsn, $db_user, $db_password, { RaiseError => 1, PrintError => 1 })
    or die "Error de conexión: $DBI::errstr";

my %errors;

validate_user_input();
login();

sub validate_user_input {
    if (!$user || length($user) == 0 || length($user) > 30) {
        $errors{user} = "Usuario inválido.";
    }

    if (!$password || length($password) == 0 || length($password) > 30) {
        $errors{password} = "Clave inválida.";
    }

    if (!$type || ($type ne "usuario" && $type ne "vendedor")) {
        $errors{type} = "Tipo inválido.";
    }
}

sub login {
    if (%errors) {
        print_errors();
        return;
    }

    my $sth = $dbh->prepare("SELECT `id`, `correo` FROM $type WHERE login_usuario = ? AND login_clave = ?");
    $sth->execute($user, $password);

    my @user_row = $sth->fetchrow_array;
    if (@user_row) {
        my $session = CGI::Session->new();
        $session->param("session_id", $user_row[0]);
        $session->param("session_name", $user_row[1]);
        $session->expire(time + $session_time);
        $session->flush();

        my $cookie = $cgi->cookie(
            -name    => "id_session_$type",
            -value   => $session->id(),
            -expires => time + $session_time,
            -max-age => $session_time,
            -secure  => 1,      # Solo enviar la cookie sobre HTTPS
            -httponly => 1,     # Accesible solo a través de HTTP
        );

        print $cgi->header(-cookie => $cookie);
    } else {
        $errors{login} = "El usuario y la clave no coinciden.";
        print_errors();
    }
}

sub print_errors {
    print "<errors>\n";
    for my $key (keys %errors) {
        print<<XML;
        <error>
            <element>$key</element>
            <message>$errors{$key}</message>
        </error>
XML
    }
    print "</errors>\n";
}
