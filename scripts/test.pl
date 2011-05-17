#!/usr/bin/perl -w

open my $fd, "<", "test2.rrd";
binmode $fd;
read $fd,my $head, 1024;
for (my $i=0; $i<length($head); $i++) {
if (ord(substr($head,$i,1)) >31 && ord(substr($head,$i,1)) < 128) {print substr($head,$i,1);}
else { print ord(substr($head,$i,1));}
print " ";
}

