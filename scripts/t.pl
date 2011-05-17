#!/usr/bin/perl

use strict;

print "Generating test.rrd using RRDTOOL ...";
my $rrd; my $count; my $val1; my $val2; my $val3; my $val4; my $i; my $j; my $start;
my $cmd;
$start=920804399;
`rrdtool create test.rrd --start $start DS:el1:COUNTER:600:U:U DS:el2:GAUGE:600:U:U DS:el3:DERIVE:600:U:U DS:el4:ABSOLUTE:600:U:U RRA:AVERAGE:0.5:1:5 RRA:AVERAGE:0.5:2:5 RRA:LAST:0.5:2:5 RRA:MAX:0.5:2:5 RRA:MIN:0.5:2:5`;
`rrdtool info test.rrd`;
$j=$start+1; $cmd="rrdtool update test.rrd $j:1:2.1:3:4"; `$cmd`;
$j+=300; `rrdtool update test.rrd $j:6471:842.4:93:484`;
$j+=300; `rrdtool update test.rrd $j:0:679.3:3:89.6`;
$j+=300; `rrdtool update test.rrd $j:34:76354.2:45:67`;
$j+=300; `rrdtool update test.rrd $j:54:257:526:7523.9`;
$j+=300; `rrdtool update test.rrd $j:6:-5:1:6.0`;
$j+=300; `rrdtool update test.rrd $j:78:6.9:45:66`;
$j+=300; `rrdtool update test.rrd $j:731:2.99:1:56.9`;
$j+=300; `rrdtool update test.rrd $j:67:1.0:789:2`;
`rrdtool dump test.rrd > test.rrdtool.xml`;
print "done.\n";

print "Generating test2.rrd using RRD::Editor ...";
use RRD::Editor;
my $rrd = RRD::Editor->new();
$rrd->create(
"--start 920804399 DS:el1:COUNTER:600:U:U"
." DS:el2:GAUGE:600:U:U DS:el3:DERIVE:600:U:U DS:el4:ABSOLUTE:600:U:U RRA:AVERAGE:0.5:1:5 RRA:AVERAGE:0.5:2:5 RRA:LAST:0.5:2:5 RRA:MAX:0.5:2:5 RRA:MIN:0.5:2:5"
);
my $j=920804400;
$rrd->update("$j:1:2.1:3:4");
$j+=300; $rrd->update("$j:6471:842.4:93:484");
$j+=300; $rrd->update("$j:0:679.3:3:89.6");
$j+=300; $rrd->update("$j:34:76354.2:45:67");
$j+=300; $rrd->update("$j:54:257:526:7523.9");
$j+=300; $rrd->update("$j:6:-5:1:6.0");
$j+=300; $rrd->update("$j:78:6.9:45:66");
$j+=300; $rrd->update("$j:731:2.99:1:56.9");
$j+=300; $rrd->update("$j:67:1.0:789:2");
$rrd->save("test2.rrd");
open my $fd, ">test2.editor.xml"; print $fd $rrd->dump();close $fd;
print "done.\n";

# now lets see if RRDTOOL and RRD::Editor can read each others files

print "Trying to open test.rrd using RRD::Editor ...";
$rrd->open("test.rrd");
open $fd, ">test.editor.xml"; print $fd $rrd->dump();close $fd;
print "done.\n";
print "Trying to open test2.rrd using RRDTOOL ...";
`rrdtool dump test2.rrd >test2.rrdtool.xml`;
print "done.\n";


