#!perl/bin/perl.exe

# Recibe: id
# Retorna: <products> <product> <name>nombre</name> <description>descripcion</description> <image>imagen</image> <price>precio</price> </product> </products>
# Check se deberia llamar al cargar la pagina para mostrar todos los productos

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $id = $cgi->param("id");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"id_session_usuario"};

if ($session_cookie) {
    my $db_user = "unsashop";
    my $db_password = "c!YxWLaRyvODyTWr";
    my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
    my $dbh = DBI->connect($dsn, $db_user, $db_password);

    my $sth = $dbh->prepare("SELECT `nombre`, `descripcion`, `imagen`, `precio`
                            FROM producto
                            WHERE producto.tienda_id = $id");
    $sth->execute;
    print_products($sth);
}

sub print_products {
    print($cgi->header("text/xml"));
    print "<products>\n";
    while (my @row = $_[0]->fetchrow_array) {
        print<<XML;
        <product>
            <name>$row[0]</name>
            <description>$row[1]</row>
            <image>$row[2]</image>
            <price>$row[3]</price>
        </product>
XML
    }
    print "</products>\n"
}
