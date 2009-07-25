use JSON::XS;
use strict;
use warnings;

#let there be colours
my $GREEN = "\e[1;32m";
my $YELLOW = "\e[1;33m";
my $CYAN = "\e[1;36m";
my $NORMAL = "\e[0m";
my $BLUE = "\e[1;34m";

unless(-e "pacdb") {
	print "Downloading package database...\n";
	if(system("wget http://pacnet.karbownicki.com/api/packages/ -O pacdb")) {#Why do I use wget instead of LWP? Just beacuse everyone has wget, and not everyone has LWP.
		die("Could not obtain package database, exiting\n");									#You think it's a bad practice? Well, fuck you.
	}
}

open(my $db, "<", "pacdb") or die ("Could not open the package database, exiting\n");
my $json;
while(<$db>) {
	$json .= $_;
}

my $packages = decode_json($json);

foreach(@{$packages}) {
	print "$CYAN$_->{category__name}$NORMAL/$GREEN$_->{name}$NORMAL $BLUE($_->{version})$NORMAL\n\t$_->{description}\n\n";
}
