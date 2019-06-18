#!/usr/bin/perl

#Andrew McLaughlin
#analyze log file
# 21 Oct 18

use warnings;
use strict;
use IO::Uncompress::Unzip qw(unzip $UnzipError);

#Uncompress zip file
my $input = "aggregateLog.log.zip";
my $output = "aggregateLog.log";
unzip $input => $output or die "unzip failed: $UnzipError\n";

my $count = 0;
my $count2 = 0;
my $count3 = 0;

#search file for keywords and count instances
open(FILE, "aggregateLog.log") or die "Could not open log\n";
while(<FILE>)
{
	if($_ =~ /error/ig)
	{
		$count++;
		&createReport;
	}
	elsif($_ =~ /problem/ig)
	{
		$count2++;
		&createReport;
	}
	elsif($_ =~ /fail(ure)*/ig)
	{
		$count3++;
		&createReport;
	}
	else{}
}
close(FILE);

#write lines where keywords appear to new file
sub createReport{
	open(STDOUT, '>>', "report.txt") or die;
		print($_);
	close(STDOUT);
}

#log creation of unzipped log and report
open(ARCHIVE, '>>', "archive.log") or die;
	my $datestring = localtime();
	print ARCHIVE "aggregateLog.log created on $datestring\nreport.txt created on $datestring\n";
close(ARCHIVE);

#notify user of the count of keyword instances
print STDERR "Error appears $count times\n";
print STDERR "Problem appears $count2 times\n";
print STDERR "Fail or Failure appears $count3 times\n";