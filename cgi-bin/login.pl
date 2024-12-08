#!/usr/bin/perl

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

my $db_user = "unsashop";
my $db_password = "c!YxWLaRyvODyTWr";
my $dsn = "dbi:mysql:database=unsashop;host=127.0.0.1";
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
}

sub login {
    if (%errors) {
        print $cgi->header("text/xml");
        print_errors();
        return;
    }

    my $sth = $dbh->prepare("SELECT `id`, `login_usuario` FROM $type WHERE login_usuario = ? AND login_clave = ?");
    $sth->execute($user, $password);

    my @user_row = $sth->fetchrow_array;
    if (@user_row) {
        my $session = CGI::Session->new(undef, undef, {Directory => '/tmp'});

        $session->param("session_id", $user_row[0]);
        $session->param("session_name", $user_row[1]);
        $session->param("session_type", $type);
        $session->expire(time + $session_time);
        $session->flush();

        my $cookie = $cgi->cookie(
            -name    => "id_session",
            -value   => $session->id(),
            -expires => time + $session_time,
            -max-age => $session_time,
            -secure  => 1,
            -httponly => 1,
        );
        if ($type eq "usuario"){
        print $cgi->header(-cookie => $cookie, -location => '../indexU.html');
        exit;
        } 
        if ($type eq "vendedor") {
        print $cgi->header(-cookie => $cookie, -location => '../indexV.html');
        exit;
        }
    } else {
        $errors{login} = "El usuario y la clave no coinciden.";
        print $cgi->header("text/xml");
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
