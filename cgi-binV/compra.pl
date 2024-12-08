#!perl/bin/perl.exe

# Recibe: nada
# Retorna: nada

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

if ($session_cookie) {
    my $db_user = "unsashop";
    my $db_password = "c!YxWLaRyvODyTWr";
    my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
    my $dbh = DBI->connect($dsn, $db_user, $db_password);

    my $session_id = $session_cookie->value();
    my $session = CGI::Session->load($session_id);
    my $buyer_id = $session->param("session_id");

    my $sth = $dbh->prepare("SELECT SUM(`producto`.`precio`)
                            FROM producto, carrito, usuario
                            WHERE carrito.producto_id = producto.id AND carrito.usuario_id = '$buyer_id'")
    $sth->execute;
    my @row = $sth->fetchrow_array;
    my $total_price = $row[0];

    $sth = $dbh->prepare("UPDATE `tarjeta`, `usuario`
                        SET `tarjeta`.`saldo` = `tarjeta`.`saldo` - '$total_price'
                        WHERE usuario.id = '$buyer_id' AND usuario.tarjeta_id = tarjeta.id")
    $sth->execute;

    $sth = $dbh->prepare("DELETE FROM `carrito`
                        WHERE usuario_id = '$buyer_id'");
    $sth->execute;

    print($cgi->header("text/xml"));
}