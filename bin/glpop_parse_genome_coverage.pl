#!/usr/bin/env perl

# Parse coverage per scaffold in Parus major genome,
# as output in the genome_results.txt file from qualimap.
# Usage: parse_genome_coverage.pl [OPTIONS] infile

use warnings;
use strict;
use Data::Dumper;
use List::Util qw(all);
use Getopt::Long;

## Globals
my $min_coverage = 0;
my $max_coverage;
my $print_coverage = 0;
my $intersection = 0;
my $verbose = 1;
my $DEBUG = 1;
my %HoH = (); # Key: sample, value: {key: scaffold_id, value: coverage)
my $keyword = '>>>>>>> Coverage per contig';

## Options
GetOptions (
    "min|coverage=i" => \$min_coverage,
    "max|x=i" => \$max_coverage,
    "intersection" => \$intersection,
    "print-coverage" => \$print_coverage,
    "verbose!" => \$verbose,
    "help" => sub {&help; exit;},
);

sub help {

print <<"END_HEREDOC";

Usage:
    $0 [options] genome_results.txt

Options:
    -i, --min,--coverage=<int> Min coverage. Default is $min_coverage.
    -x, --max=<int>            Max coverage. No default value.
    -i, --intersection         Print scaffold IDs where all input
                               genomes fulfill min coverage (and max, 
                               if set).
    -p, --print-coverage       Foreach input genome, print coverage
                               for all scaffolds.
    -h, --help                 Print this help and exit.

Input:
    genome_results.txt         Output file from qualimap. Can read several
                               files.

Output:
                               Prints to stdout.
END_HEREDOC

}


while (my $infile = shift) {
    open my $GF, "<", $infile or die "$!";
    my $sample = "";
    my $found_keyword = 0;
    while (<$GF>) {
        my $line = $_;
        next if ($line =~ /^\s*$/);
        chomp($line);
        if (/\s+bam\s+file\s+=\s+(.*)_rmdup.bam/) { # C_cyanus_R-84509_rmdup.bam
            $sample = $1;
        }
        if ($line =~ /$keyword/) {
            $found_keyword = 1;
            next;
        }
        if ($found_keyword) {
            my (@parts) = split /\s+/, $line;
            my $scaffold = $parts[1];
            my $coverage = $parts[4];
            $HoH{$sample}{$scaffold} = $coverage;
        }
    }
    close ($GF);
}

# print_coverage
if ($print_coverage) {
    for my $sample (keys %HoH) {
        for my $scaf (keys %{$HoH{$sample}}) {
            my $cov = $HoH{$sample}{$scaf};
            if ($cov >= $min_coverage) {
                if ($max_coverage) {
                    if ($cov <= $max_coverage) {
                        print "$sample\t$scaf\t$cov\n";
                    }
                }
                else {
                    print "$sample\t$scaf\t$cov\n";
                }
            }
        }
    }
}

# Print only scaffolds where all samples have max_coverage >= cov >= min_coverage
if ($intersection) {
    my %HoA = ();
    for my $sample (keys %HoH) {
        for my $scaf (keys %{$HoH{$sample}}) {
            my $cov = $HoH{$sample}{$scaf};
            push @{$HoA{$scaf}}, $cov;
        }
    }
    for my $key (sort keys %HoA) {
        if (all {$_ >= $min_coverage} @{$HoA{$key}}) {
            if ($max_coverage) {
                if (all {$_ <= $max_coverage} @{$HoA{$key}}) {
                    print STDOUT $key, "\n";
                }
            }
            else {
                print STDOUT $key, "\n";
            }
        }
    }
}

