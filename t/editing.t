#!perl -w

use Test::Simple tests => 15;
use File::Spec;
use File::Basename qw(dirname);
my $scriptdir=File::Spec->rel2abs(dirname(__FILE__));

use RRD::Editor;

my $rrd = RRD::Editor->new();
ok( defined $rrd, 'new()' );
$rrd->open("t/test.rrd");

# do some DSediting
ok($rrd->rename_DS("el1","new1"),"rename_DS()");
ok($rrd->set_DS_heartbeat("el2",1200), "set_DS_heartbeat()");
ok($rrd->set_DS_type("el2","ABSOLUTE"),"set_DS_type()");
ok($rrd->set_DS_min("el2",0),"set_DS_min()");
ok($rrd->set_DS_max("el2",1),"set_DS_max()");
ok($rrd->add_DS("DS:added:GAUGE:600:U:U"),"add_DS()");
ok($rrd->delete_DS("el3"),"delete_DS()");
#open $fd, ">t/test.rrd.ds_editing.dump"; print $fd $rrd->dump(); close $fd;
# is result what we expect ?
open $fd, "<$scriptdir/test.rrd.ds_editing.dump"; @file=<$fd>; ;close $fd;
ok ($rrd->dump() eq join("",@file), "DS editing");
$rrd->close();

# do some RRA editing
$rrd->open("t/test.rrd");
ok($rrd->set_RRA_xff(1,0), "set_RRA_xff()");
ok($rrd->set_RRA_el(1,"el1",2,100),"set_RRA_el()");
ok($rrd->resize_RRA(1,20), "resize_RRA()");
ok($rrd->add_RRA("RRA:AVERAGE:0.5:3:10"),"add_RRA()");
ok($rrd->delete_RRA(0),"delete_RRA()");
#open $fd, ">t/test.rrd.rra_editing.dump"; print $fd $rrd->dump(); close $fd;
# is result what we expect ?
open $fd, "<$scriptdir/test.rrd.rra_editing.dump"; @file=<$fd>; ;close $fd;
ok ($rrd->dump() eq join("",@file), "RRA editing");
$rrd->close();

