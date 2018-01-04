#!/usr/bin/perl
use strict;
use warnings;
use GTFnkonstan;

### Header:
# Calls upon subroutines which count the number of genes, count
# the number of exons, calculate the average exon length, and
# identify the gene with the highest number of exons.
# File created: 23/4/2017. File last modified: 23/4/17.

### Checks whether the user's input after perl gtf_nkonstan.pl is equal to the flag. If it does, runs the subroutines in GTFnkonstan.pm.
if ($ARGV[1] eq "-h"){

	GTFnkonstan::help();
}

if ($ARGV[1] eq "-g"){

	GTFnkonstan::gene($ARGV[0]);
}

if ($ARGV[1] eq "-e"){

	GTFnkonstan::exons($ARGV[0]);
}

if ($ARGV[1] eq "-a"){

	GTFnkonstan::avg($ARGV[0]);
}

if ($ARGV[1] eq "-n"){

	GTFnkonstan::mostexons($ARGV[0]);
}

