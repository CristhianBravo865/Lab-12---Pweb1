#!perl/bin/perl.exe

# Recibe: action (check [revisa todos los productos], add [añade un producto], remove [remueve un producto])
#    check => nada
#    add => id
#    remove => id
# Retorna:
#    check => <products> <product> <shop>nombre tienda</shop> <name>nombre</name> <description>descripcion</description> <image>imagen</image> <price>precio</price> </product> </products>
#    add => nada
#    remove => nada
# Check se deberia llamar al cargar la pagina para mostrar todas las tiendas

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $action = $cgi->param("action");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"id_session_usuario"};

if ($session_cookie) {
    my $db_user = "unsashop";
    my $db_password = "c!YxWLaRyvODyTWr";
    my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
    my $dbh = DBI->connect($dsn, $db_user, $db_password);

    my $session_id = $session_cookie->value();
    my $session = CGI::Session->load($session_id);
    my $buyer_id = $session->param("session_id");

    if ($action eq "check") {
        my $sth = $dbh->prepare("SELECT `tienda`.`nombre`, `producto`.`nombre`, `producto`.`descripcion`, `producto`.`imagen`, `producto`.`precio`
                                FROM carrito, tienda, producto
                                WHERE carrito.usuario_id = '$buyer_id' AND producto.id = carrito.producto_id AND tienda.id = producto.tienda_id");
        $sth->execute;
        print_products($sth);
    } else {
        my $product_id = $cgi->param("id");
        if ($action eq "add") {
            my $sth = $dbh->prepare("INSERT INTO carrito (usuario_id, producto_id) VALUES ($buyer_id, $product_id)");
            $sth->execute();
        } elsif ($action eq "remove") {
            my $sth = $dbh->prepare("DELETE FROM `carrito` WHERE usuario_id = '$buyer_id' AND producto_id = '$product_id'");
            $sth->execute();
        }
        print($cgi->header("text/xml"));
    } 
}

sub print_products {
    print($cgi->header("text/xml"));
    print "<products>\n";
    while (my @row = $_[0]->fetchrow_array) {
        print<<XML;
        <product>
            <shop>$row[0]</shop>
            <name>$row[1]</name>
            <description>$row[2]</row>
            <image>$row[3]</image>
            <price>$row[4]</price>
        </product>
XML
    }
    print "</products>\n"
}
