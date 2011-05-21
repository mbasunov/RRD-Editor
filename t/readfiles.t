#!perl -w

use Test::Simple tests => 17;
use File::Spec;
use File::Basename qw(dirname);
my $scriptdir=File::Spec->rel2abs(dirname(__FILE__));

use RRD::Editor;

my $rrd = RRD::Editor->new();
ok( defined $rrd, 'new()' );
ok($rrd->open("$scriptdir/test.rrd"), 'open()');
open my $fd, "<$scriptdir/test.rrd.info"; my @file=<$fd>; my $file=join("",@file);
ok(lc($rrd->info("-n -d 5")) eq lc($file), 'info()');
#open $fd,">2"; print $fd $rrd->info("-n -d 5"); close $fd;
open $fd, "<$scriptdir/test.rrd.dump"; @file=<$fd>;  $file=join("",@file);
my $dump=$rrd->dump("-t -d=5"); #$dump=~ s/UTC/GMT/g;
#open $fd,">2"; print $fd $rrd->dump("-t -d 5"); close $fd;
ok(lc($dump) eq lc($file), 'dump()');
open $fd, "<$scriptdir/test.rrd.fetch"; @file=<$fd>;  $file=join("",@file);
ok(lc($rrd->fetch("AVERAGE -s 920804399 -d=5")) eq lc($file), "fetch()"); 
ok($rrd->last() == 920806800, 'last():'.$rrd->last());
ok($rrd->minstep() == 300, 'minstep():'.$rrd->minstep() );
ok(join(" ",$rrd->lastupdate()) eq "67 1.0 789 2", 'lastupdate():'.join(" ",$rrd->lastupdate()));
ok(join(" ",$rrd->DS_names()) eq "el1 el2 el3 el4", "DS_names():".join(" ",$rrd->DS_names()));
ok($rrd->DS_heartbeat("el1") == 600, "DS_heartbeat():".$rrd->DS_heartbeat("el1")); 
ok($rrd->DS_type("el1") eq "COUNTER", "DS_type():".$rrd->DS_type("el1"));
ok(lc($rrd->DS_min("el1")) eq "nan", "DS_min():".$rrd->DS_min("el1"));
ok(lc($rrd->DS_max("el1")) eq "nan", "DS_max():".$rrd->DS_max("el1"));
ok($rrd->RRA_numrows(0) == 5, "RRA_numrows():".$rrd->RRA_numrows(0));
ok($rrd->RRA_xff(0) == 0.5, "RRA_xff():".$rrd->RRA_xff(0));
ok($rrd->RRA_step(0) == 300, "RRA_step():".$rrd->RRA_step(0));
(my $t, my $el) = $rrd->RRA_el(0,"el1",2);
ok($t==920806200 && sprintf("%0.2f",$el) eq "0.24","RRA_el():".join(" ",$rrd->RRA_el(0,"el1",2)));

