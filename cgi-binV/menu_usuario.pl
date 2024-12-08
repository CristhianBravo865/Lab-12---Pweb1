#!perl/bin/perl.exe

# Recibe: nada
# Retorna: check => <shops> <shop> <id>id</id> <name>nombre</name> <description>descripcion</description> <open>1 o 0</open> </shop> </shops>
# Check se deberia llamar al cargar la pagina para mostrar todas las tiendas

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"id_session_usuario"};

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password);


if ($session_cookie) {
    my $session_id = $session_cookie->value();
    my $session = CGI::Session->load($session_id);
    my $buyer_id = $session->param("session_id");

    my $sth = $dbh->prepare("SELECT `id`, `nombre`, `descripcion`, `abierto` FROM tienda");
    $sth->execute();
    print_shops($sth);
}

sub print_shops {
    print($cgi->header("text/xml"));
    print "<shops>\n";
    while (my @row = $_[0]->fetchrow_array) {
        print<<XML;
        <shop>
            <id>$row[0]</id>
            <name>$row[1]</name>
            <description>$row[2]</row>
            <open>$row[3]</open>
        </shop>
XML
    }
    print "</shops>\n"
}
