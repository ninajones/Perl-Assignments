#!/usr/bin/perl
use strict; 
use warnings;
use Bio::Tools::Run::StandAloneBlastPlus;
use Bio::SearchIO;
use Bio::DB::SwissProt;
use Bio::Tools::Run::Alignment::Muscle;
use Bio::AlignIO;

### Header:
# This script uses BioPerl modules to do the following: reads P11802.fasta 
# and runs a local BLAST search using uniprot_sprot.fasta, parses the BLAST 
# results, converts them to FASTA format, and creates a multiple sequence 
# alignment using MUSCLE. This script also uses a system call to open this 
# alignment with Clustal X.
# File last modified: 07/05/17.

# Initialises the variables
my $factory;
my $result;
my $in = "blast.txt";
my $hitstxt = "hits.txt";
my $report_obj;
my $hit;
my $hsp;
my @accession;
my $hitsfa = "hits.fasta";
my $sequence;
my $access;
my $seq;
my $seq2;
my $muscle;
my $align;
my $out2;

# Creates a temporary BLAST database from a FASTA file
$factory = Bio::Tools::Run::StandAloneBlastPlus->new(
	-db_name => 'swissprot',
    -db_data => 'uniprot_sprot.fasta',
    -create => 1
);

# Prints what is in quotations to terminal
print "Running BLAST.\n";

# Feeds the query into blastp and defines the BLAST output file
$result = $factory->blastp( 
    -query => 'P11802.fasta',     
    -outfile => 'blast.txt',
	# Ensures that only the top 10 BLAST hits are written to blast.txt
	-method_args => [-num_alignments => 10] );

# Prints what is in quotations to terminal
print "Parsing BLAST results.\n";

# opens the BLAST output file for reading and opens hits.txt for writing
open(IN, "<$in");
open (HITSTXT, ">$hitstxt") or die "error creating $hitstxt";

# Gets the parsed BLAST report and writes it to hits.txt
$report_obj = new Bio::SearchIO(-format => 'blast',
                                -file   => 'blast.txt');
while (<IN>) {
	while( $result = $report_obj->next_result ) {
		while( $hit = $result->next_hit ) {
			while( $hsp = $hit->next_hsp ) {				
				print HITSTXT "Sequence Identifier: ", $hit->accession, "\tScore: ", 
				$hsp->bits, "\tExpect-value: ", $hsp->evalue, "\tPercent Identity: ",
				$hsp->percent_identity, "\n";

				# Stores the accession codes in an array called @accession
				push @accession, $hit->accession; 
			}
        }
    }
} 

# Prints what is in quotations to terminal
print "Printing parsed BLAST results in FASTA format.\n";

# Get sequences from the array @accession and write just the FASTA 
# format information onto hits.fasta using a BioPerl module
$sequence = Bio::DB::SwissProt->new(); 
open (HITSFA, ">$hitsfa") or die "error creating $hitsfa.";
foreach $access (@accession) {
	$seq = $sequence->get_Seq_by_acc($access);
	$seq2 = $seq->seq();
	print HITSFA ">$access\n", $seq2,"\n";
}

# Prints what is in quotations to terminal
print "Performing a multiple sequence alignment using MUSCLE.\n";

# Uses a BioPerl module to do a simple align of hits.fasta using Muscle
$muscle = Bio::Tools::Run::Alignment::Muscle->new();
$align  = $muscle->align("$hitsfa");

# Writes the alignment to hits.aln
$out2 = Bio::AlignIO->new(-file   => ">hits.aln",
                          -format => 'clustalw');

# Turns the simple align into a multiple sequence alignment to be written to hits.aln
$out2->write_aln($align);

# Prints what is in quotations to terminal
print "Opening MUSCLE results with ClustalX.\n";

# Uses system call to open the multiple sequence alignment with Clustal X
system "clustalx hits.aln";

# Exits the system call
exit;

# Deletes the temporary BLAST database files
$factory->cleanup;

# Closes all files opened for reading and writing
close IN;
close HITSTXT; 
close HITSFA;
