#!/usr/bin/perl
use strict;
use warnings;

### Header:
# This script converts the FASTQ format file cns.fq into a FASTA format file cns.fa.
# This script also stores the gene names and corresponding sequences in a Perl DBM database.
# File created: 14/4/2017. File last modified: 23/4/17.

### Creates a new directory using system call
system "mkdir nkonstan_sequences";

### Initialises the variables
my $fafile = "nkonstan_sequences/cns.fa";
my $fastq_in="cns.fq";
my $id;
my %DATA = ();
my $flag;
my $findfile;

### Opens FASTQ file cns.fq for reading and the output OUTFA file cns.fa for writing
open(FASTQ, "<$fastq_in");
open (OUTFA, ">$fafile") or die "error creating $fafile";

### Regex used to extract gene names and sequence information for converting FASTQ to FASTA
### $flag = 1 is the sequence state and $flag = 2 is the quality state
while(<FASTQ>)
{
	if ($_ =~ /^\@(\S{1,20})\n/)
	{
		$flag = 1;
		$_=~s/^\@/>/;
	}
	elsif ($_ =~ /^\+\n/)
	{
		$flag = 2;
	}
	if ($flag == 1) 
	{
		print OUTFA $_;
	}	
}

### Closes the FASTQ and FASTA files.
close FASTQ;
close OUTFA; 

### Checks if the DBM files already exist to avoid adding to them and making them huge.
$findfile = 'nkonstan_sequences/FQtoFA.dir';
if (-e $findfile) {
    print "Database files are already present.";
}

### opens FASTQ and OUTFA for reading and opens the database %DATA
open(FASTQ, "<$fastq_in");
open (OUTFA, "<$fafile") or die "error creating $fafile"; # > means for writing only, < is read only
dbmopen (%DATA, "nkonstan_sequences/FQtoFA", 0644) or die ("error");

### Regex used to extract gene names and sequence information for storing in a Perl DBM Database
while (<OUTFA>) {
	if ($_ =~ /^\>(\S{1,20})\n/) {chomp; $id = $1;} 
	else {$DATA{$id} .= $_;}
}

### When script is run with a sequence identifier (gene name) in the command line, prints the gene name and sequence
if ($DATA{$ARGV[0]}) {
		print "Sequence ID: \>$ARGV[0]\nSequence: $DATA{$ARGV[0]}\n\n";
}

### Closes the FASTQ, FASTA and %DATA files.
close FASTQ; #Cleanup
close OUTFA; 
dbmclose %DATA;
