#!/usr/bin/perl -w

use WWW::Mechanize;
use FileHandle;

# fill ip_list.txt with list of phone urls
# http://ip.of.phone1
# http://ip.of.phone2

my $uri_list = "ip_list.txt";
my $mech = WWW::Mechanize->new(timeout => 5);

$urilist = FileHandle->new; 
if ($urilist->open("< $uri_list")) {

foreach $uri (<$urilist>) {
	chomp $uri;
	$mech->get( $uri );
	
	if ( $mech->success( ) ) {

		my $content = $mech->text();
		if  ($content =~ /.*MAC\sAddress.*([0-9a-fA-F]{12}).*App\sLoad\sID(.*)\s?Boot.*/) { 
			print "$uri\t$1\t$2\n"; 
		} elsif ($content =~ /.*MAC\sAddress.*([0-9a-fA-F]{12})P?.*App\sLoad.*:\s(.*)\s-1S.*/) {
				print "$uri\t$1\t$2\n";
			} else {
				print "$uri\tunsupported\n";
			}
		
		$EXIT_CODE=0;
		
	} else {
	
		print "Fail:",$mech->response->status_line(),"\n";
		$EXIT_CODE=0;
	}
}

$urilist->close;
} else {print "BOOM goes the dynamite!";}
