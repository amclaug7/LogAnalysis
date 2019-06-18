#!/usr/bin/perl

#Andrew Mclaughlin
#aggregate linux log files
# 21 Oct 18

use strict;
use warnings;
use IO::Compress::Zip qw(zip $ZipError);

#gets filenames of log files from various directories
opendir(DH, "/var/log") or die "Could not open log\n";
my @logs = readdir(DH);
close DH;

opendir(DH, "/var/log/apt") or die "Could not open apt\n";
push @logs, readdir(DH);
close DH;

opendir(DH, "/var/log/vmware") or die "Could not open vmware\n";
push @logs, readdir(DH);
close DH;

#Aggregates log files into one
open(OUTPUT, '>', "aggregateLog.log");

	foreach my $log (@logs)
	{
		if ($log =~ /(.)log/)
		{
			open(INPUT, '<', "/var/log/$log") or open(INPUT, '<', "/var/log/apt/$log") oropen(INPUT, '<', "/var/log/vmware/$log") or die;


			while(<INPUT>)
			{
				print OUTPUT;
			}

			close(INPUT);
		}
		else{}
	}
close(OUTPUT);

#zips new log file and deletes it
my $input = "aggregateLog.log";
zip $input => "$input.zip" or die "zip failed: $ZipError\n";

unlink("aggregateLog.log");

#Creates record of creation of zip file
open(ARCHIVE, '>>', "archive.log");
	my $datestring = localtime();
	print ARCHIVE ("aggregateLog.log.zip created $datestring\n");
close(ARCHIVE);

#deletes original log files
foreach my $log (@logs)
{
	if ($log =~ /(.)log/)
	{
		unlink("/var/log/$log") or unlink("/var/log/apt/$log") or unlink("/var/log/vmware/$log");
	}
	else{}
}