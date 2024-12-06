#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

# Configuración de conexión
my $database = "biblioteca";
my $hostname = "biblioteca-db";              
my $port     = 3306;   
my $username = "Admin";  
my $password = "password";   

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

# Validar conexión
if ($dbh) {
    print "Content-type: text/html\n\n";  
} else {
    die "Content-type: text/html\n\nError al conectar a la base de datos: $DBI::errstr\n";
}

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();
