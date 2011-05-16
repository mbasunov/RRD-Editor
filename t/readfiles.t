#!perl -w

use Test::Simple tests => 17;

use RRD::Editor;

my $rrd = RRD::Editor->new();
ok( defined $rrd, 'new()' );
ok($rrd->open("t/test.rrd"), 'open()');
open my $fd, "<t/test.rrd.info"; my @file=<$fd>; my $file=join("",@file);
ok($rrd->info("-n") eq $file, 'info()');
#open $fd,">2"; print $fd $rrd->info("-n"); close $fd;
open $fd, "<t/test.rrd.dump"; @file=<$fd>;  $file=join("",@file);
ok($rrd->dump() eq $file, 'dump()');
open $fd, "<t/test.rrd.fetch"; @file=<$fd>;  $file=join("",@file);
ok($rrd->fetch("AVERAGE -s 920804399") eq $file, "fetch()"); 
ok($rrd->last() == 920806800, 'last()');
ok($rrd->minstep() == 300, 'minstep()');
ok(join(" ",$rrd->lastupdate()) eq "67 1.0 789 2", 'lastupdate()');
ok(join(" ",$rrd->DS_names()) eq "el1 el2 el3 el4", "DS_names()");
ok($rrd->DS_heartbeat("el1") == 600, "DS_heartbeat()"); 
ok($rrd->DS_type("el1") eq "COUNTER", "DS_type()");
ok($rrd->DS_min("el1") eq "nan", "DS_min()");
ok($rrd->DS_max("el1") eq "nan", "DS_max()");
ok($rrd->RRA_numrows(0) == 5, "RRA_numrows()");
ok($rrd->RRA_xff(0) == 0.5, "RRA_xff()");
ok($rrd->RRA_step(0) == 300, "RRA_step()");
ok(join(" ",$rrd->RRA_el(0,"el1",2)) eq "920806200 0.24","RRA_el()");

