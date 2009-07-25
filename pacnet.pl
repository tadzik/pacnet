#!/usr/bin/perl
use JSON::XS;
use strict;
use warnings;

#let there be colours
my $GREEN = "\e[1;32m";
my $YELLOW = "\e[1;33m";
my $CYAN = "\e[1;36m";
my $NORMAL = "\e[0m";
my $BLUE = "\e[1;34m";
my $packages; #here be database

sub getdb() {
	print ":: Downloading package database...\n";
	if(system("wget http://pacnet.karbownicki.com/api/packages/ -O pacdb")) {#Why do I use wget instead of LWP? Just beacuse everyone has wget, and not everyone has LWP.
		die(":: Could not obtain package database, exiting\n");
  }
}

sub readdb() {
	getdb unless(-e "pacdb");
	
	open(my $db, "<", "pacdb") or die ("Could not open the package database, exiting\n");
	my $json;
	$json .= $_	while(<$db>);
	$packages = decode_json($json);
}

sub printall() {
	for(@{$packages}) {
		print "$CYAN$_->{category__name}$NORMAL/$GREEN$_->{name}$NORMAL $BLUE($_->{version})$NORMAL\n\t$_->{description}\n\n";
	}
}

#main
readdb();
my $args = @ARGV;

if(!$args) {
	printall;
} else {
	for(@{$packages}) {
		if($_->{name} =~ ${ARGV[0]}) {
			print "$CYAN$_->{category__name}$NORMAL/$GREEN$_->{name}$NORMAL $BLUE($_->{version})$NORMAL\n\t$_->{description}\n\n";
		}
	}
}
