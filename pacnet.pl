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

sub categories() {
	my $catname = shift @ARGV;
	if($catname) {
		for(@{$packages}) {
			if($_->{category__name} eq $catname) {
				print "$CYAN$_->{category__name}$NORMAL/$GREEN$_->{name}$NORMAL $BLUE($_->{version})$NORMAL\n\t$_->{description}\n\n";
			}
		}
	} else {
		my @cats;
		for(@{$packages}) {
			my $found;
			for my $cat (@cats) {
				if($_->{category__name} eq $cat) {
					$found = 1;
					last;
				}
			}
			unless($found) {
				push @cats, $_->{category__name};
			}
		}
		print ":: The following categories are available:\n\n";
		print "$_\n" for(sort @cats);
	}
}

sub getdb() {
	print ":: ${BLUE}Downloading package database...$NORMAL\n";
	if(system("wget http://pacnet.karbownicki.com/api/packages/ -O ~/.pacnet.db")) {#Why do I use wget instead of LWP? Just beacuse everyone has wget, and not everyone has LWP.
		die(":: Could not obtain package database, exiting\n");
  }
}

sub printall() {
	for(@{$packages}) {
		print "$CYAN$_->{category__name}$NORMAL/$GREEN$_->{name}$NORMAL $BLUE($_->{version})$NORMAL\n\t$_->{description}\n\n";
	}
}

sub readdb() {
	getdb unless(-e "~/.pacnet.db");
	
	open(my $db, "<", "~/.pacnet.db") or die("Could not open the package database, exiting\n");
	my $json;
	$json .= $_	while(<$db>);
	$packages = decode_json($json);
}

sub usage() {
	print <<'END';
pacnet usage:
  -c             => list all available categories
  -c <category>  => list all packages in specified category
  -h             => show usage info (you are reading it now :>)
  -s             => synchronise package database
  <regexp>       => search for a package with name matching provided regexp
END
}

readdb();
my $args = @ARGV;

if(!$args) {
	printall;
} else {
	my $arg = shift @ARGV;
	if($arg eq "-s") {
		getdb;
	} elsif($arg eq "-c") {
		categories;
	} elsif($arg eq "-h" || $arg eq "--help"){
		usage;
	} else {
		for(@{$packages}) {
			if($_->{name} =~ $arg) {
				print "$CYAN$_->{category__name}$NORMAL/$GREEN$_->{name}$NORMAL $BLUE($_->{version})$NORMAL\n\t$_->{description}\n\n";
			}
		}
	}
}
