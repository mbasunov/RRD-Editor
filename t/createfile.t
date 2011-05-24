#!perl -w

use Test::Simple tests => 20;
use RRD::Editor;
#use String::Escape qw( printable unprintable );
use File::Spec;
use File::Basename qw(dirname);
my $scriptdir=File::Spec->rel2abs(dirname(__FILE__));

my $rrd = RRD::Editor->new();
ok( defined $rrd, 'new()' );
ok( $rrd->create("--format=portable-double --start=920804399 DS:el1:COUNTER:600:U:U DS:el2:GAUGE:600:U:U DS:el3:DERIVE:600:U:U DS:el4:ABSOLUTE:600:U:U RRA:AVERAGE:0.5:1:5 RRA:AVERAGE:0.5:2:5 RRA:LAST:0.5:2:5 RRA:MAX:0.5:2:5 RRA:MIN:0.5:2:5"), "create()");
my $j=920804400; 
ok( $rrd->update("$j:1:2.1:3:4"), "update()" );
$j+=300; ok($rrd->update("$j:6471:842.4:93:484"));
$j+=300; ok($rrd->update("$j:0:679.3:3:89.6"));
$j+=300; ok($rrd->update("$j:34:76354.2:45:67"));
$j+=300; ok($rrd->update("$j:54:257:526:7523.9"));
$j+=300; ok($rrd->update("$j:6:-5:1:6.0"));
$j+=300; ok($rrd->update("$j:78:6.9:45:66"));
$j+=300; ok($rrd->update("$j:731:2.99:1:56.9"));
$j+=300; ok($rrd->update("$j:67:1.0:789:2"));

# check that RRD contents are as expected
open my $fd, "<$scriptdir/test.rrd.dump"; my @file=<$fd>;  my $file=join("",@file); close $fd;
#open $fd, ">2"; print $fd $rrd->dump("-t -d=5");close $fd;
my $dump=$rrd->dump("-t -d=5"); #$dump=~ s/UTC/GMT/g;
ok(lc($dump) eq lc($file), 'dump()');

# now do our best to check whether we can save the file in a portable-double format
# save portable-double format file to memory
my $fileDB='';
$rrd->{file_name}=\$fileDB;
$rrd->{encoding}="portable-double";
ok($rrd->save(),"save()"); # save RRD to string in memory (no need for temp file)
ok($rrd->close(),"close()");

# save portable-single format file to memory
my $fileDB_single='';
$rrd->{file_name}=\$fileDB_single;
$rrd->{encoding}="portable-single";
ok($rrd->save(),"save()"); # save RRD to string in memory (no need for temp file)
ok($rrd->close(),"close()");

# check that portable-double header is binary compatible (can't check whole header, or file body, due to random selection of rraptr values)
$rrd->open("$scriptdir/test.rrd"); my $header=$rrd->_get_header_size()-$rrd->{RRA_PTR_EL_SIZE} * $rrd->{rrd}->{rra_cnt}-$rrd->{HEADER_PAD}; $rrd->close();
ok($header == 3188, "double header:".$header);
my $size=1800; # pick out onyl first part of header, as otherwise get small bit differences depending of float precision used by perl (e.g. between 32 and 64 bit machines)
open $fd, "<$scriptdir/test.rrd"; binmode $fd; read($fd,$file,1800);close $fd; 
ok ($file eq substr($fileDB,0,1800), "save() header portable-double");
#print printable($file),"\n\n";
#print printable(substr($fileDB,0,$header));

# and now check portable-single format
$rrd->open("$scriptdir/test.rrd.single"); $header=$rrd->_get_header_size()-$rrd->{RRA_PTR_EL_SIZE} * $rrd->{rrd}->{rra_cnt}-$rrd->{HEADER_PAD}; $rrd->close();
ok($header == 1824, "single header: ".$header);
open $fd, "<$scriptdir/test.rrd.single"; binmode $fd; read($fd,$file,$header);close $fd;
ok ($file eq substr($fileDB_single,0,1824), "save() header portable-single");


