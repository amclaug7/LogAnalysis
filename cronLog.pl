#!/usr/bin/perl

#Andrew McLaughlin
#set up crontab
#21 Oct 18

use strict;
use warnings;

open(FH, "| crontab -") or die "Can't open crontab\n";
	my $cron = qx(crontab -l);
	
	print FH "${cron}0 0 * * 1 /home/student/aggregateLog.pl\n";
	print FH "${cron}0 0 * * 1 find /home/student -type f -mtime +540 -exec rm {}
close(FH);