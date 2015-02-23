#!/usr/bin/perl

use Time::HiRes qw/time/;

use strict;

my $t0 = time;

sub min { return $_[0] < $_[1] ? $_[0] : $_[1]; }

my @pages = ();
while (<>) {
    if(/^en /) {
        my @w = split;
        if ($w[2] > 500) {
            push @pages, [$w[1], $w[2]];
        }
    }
}

@pages = sort {$b->[1] <=> $a->[1]} @pages;

my $t1 = time;

printf "Query took %.2f seconds\n", $t1-$t0;

for my $i (0..min(9, $#pages)) {
    print "$pages[$i][0] ($pages[$i][1])\n";
}
