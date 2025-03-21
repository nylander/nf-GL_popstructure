#! /usr/bin/env perl
#
# Extract output from nf-GL_popstructure
# to a pong_filemap to be used in plotting
# See <https://github.com/ramachandran-lab/pong>
#
# Usage: ./NGSadmix2pong.pl directory > file_map
#
# Will automatically read folder ../output if
# it exists.
#
# Author nylander <johan.nylander@nrm.se>
# Version 0.1
# Copyright (C) 2025 nylander <johan.nylander@nrm.se>
# Created  2025-03-19 10:05
# Last modified: fre mar 21, 2025  04:35

use strict;
use warnings;
use File::Find;
use File::Basename;
use Sort::Key::Natural qw(natsort);

my $VERSION = "0.2";
my @q_list = ();
my %HoH = ();

my $directory = '';

if (scalar($ARGV[0])) {
    if ($ARGV[0] eq "-h" || $ARGV[0] eq "--help") {
        print "Usage: $0 <directory>\n";
        exit;
    }
    if ($ARGV[0] eq "-v" || $ARGV[0] eq "-V" || $ARGV[0] eq "--version") {
        print "$0 v$VERSION\n";
        exit;
    }
    if (-d $ARGV[0]) {
        $directory = $ARGV[0];
    }
    else {
        die "ERROR: input directory $directory does not exist\nUsage: $0 <directory>\n";
    }
}
else {
    if (-d "../output") {
        $directory = "../output";
    }
    else {
        die "ERROR: input directory $directory does not exist\nUsage: $0 <directory>\n";
    }
}

find(\&wanted, $directory);

foreach my $qfile (@q_list) {
    my $basename = basename($qfile, '.qopt');
    my $k;
    if ($basename =~ /.+_k(\d+)_permutate(\d+)/) {
        $k = $1;
    }
    else {
        die "Could not find k from filename\n";
    }
    $qfile =~ s/.+02\.NGSadmix\/(.+)/$1/;
    $HoH{$basename}{'path'} = $qfile;
    $HoH{$basename}{'k'} = $k;
}

foreach my $basename (natsort keys(%HoH)) {
    print STDOUT "$basename\t$HoH{$basename}{'k'}\t$HoH{$basename}{'path'}\n";
}

sub wanted {
    return unless -f;
    return unless /\.qopt$/;
    push @q_list, $File::Find::name;
}
