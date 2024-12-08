#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;
use JSON;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
print $cgi->header('application/json');

my $json_input = $cgi->param('POSTDATA');
my $producto = decode_json($json_input);

my $nombreP = $producto->{nombre};
my $precioP = $producto->{precio};
my $imagenP = $producto->{imagen};
my $stockP = $producto->{stock};


my $session_cookie = $cgi->cookie("id_session") || '';
my $session = CGI::Session->new(undef, $session_cookie, {Directory => '/tmp'});

my $user_id = $session->param("session_id");
my $user_type = $session->param("session_type");

my %errors;
#$error{datos} = ($nombreP);

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $db_user, $db_password);

validate_data();

sub validate_data {
    if (length($nombreP) == 0 || length($nombreP) > 30) {
        $errors{nombreP} = "Ingrese un nombre válido." + $nombreP;
    }

    if ($precioP > 100 || $precioP <= 0) {
        $errors{precioP} = "Ingrese un precio válido.";
    }

    if (!$imagenP || length($imagenP) == 0 || $imagenP !~ /^(?:https?|ftp):\/\/\S+$/i) {
        $errors{imagenP} = "Ingrese una imagen válida.";
    }
    
    if ($stockP > 1000 || $stockP <= 0) {
        $errors{stockP} = "Ingrese un stock válido.";
    }

    #VERIFICAR QUE EL PRODCUTO NO EXISTA YA - NOMBRE
    my $sth_n = $dbh->prepare("SELECT COUNT(*) FROM producto WHERE nombre = ?");
    $sth_n->execute($nombreP);
    my $countN = $sth_n->fetchrow_array();

    if ($countN > 0) {
    $errors{nombreP} = "Ya existe un producto con el mismo nombre.";
    }

    #VERIFICAR QUE EL PRODCUTO NO EXISTA YA - IMAGEN
    #my $sth_i = $dbh->prepare("SELECT COUNT(*) FROM producto WHERE imagen = ?");
    #$sth_i->execute($imagenP);
    #my $countI = $sth_i->fetchrow_array();

    #if ($countI > 0) {
    #$errors{imagenP} = "Ya existe un producto con la misma imagen.";
    #}
}

if (%errors) {
    my $response_data = {
        success => 0,
        errors => \%errors
    };
    print encode_json($response_data);
} else {
    my $sth = $dbh->prepare("INSERT INTO producto (`vendedor_id`, `nombre`, `imagen`, `precio`, `stock`) VALUES (?, ?, ?, ?, ?)");
    $sth->execute($user_id, $nombreP, $imagenP, $precioP, $stockP);

    my $response_data = {
        success => 1,
        message => "Producto agregado exitosamente"
    };
    print encode_json($response_data);
}
