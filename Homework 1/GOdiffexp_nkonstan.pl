#!/usr/bin/perl
# GOdiffexp_nkonstan.pl
use strict; 
# makes you define variables as either local or global
use warnings;
# tells you what the problem is and the line in which it is located

my $genelist = "GO0003723.genelist";
# declares the string which is assigned to GO0003723.genelist
my $diffexp = "diffexp.tsv";
# declares the string which is assigned to diffexp.tsv
my $output = "output_nkonstan.tsv";
# declares the string which is assigned to the output file
my @gene;
# declares the array that is formed by elements from GO0003723.genelist that are separated by tabs
my @tsv;
# declares the array that is formed by elements from diffexp.tsv that are separated by tabs
my $line;
# declares the string representing each line of the file that is to be read
my %hash1;
# declares the first hash with keys being the gene names and values being the descriptions
my %hash2;
# declares the second hash with keys being the gene names and values being the p-values
my @k;
# declares the array consisting of the keys from hash1
my $genename;
# declares the string that is compared betweeh hash1 and hash2

open (GENELIST, "$genelist") or die;
# opens GO0003723.genelist to be read
open (DIFFEXP, "$diffexp") or die;
# opens diffexp.tsv to be read
open (OUTPUT, ">$output") or die "error creating output_nkonstan.tsv";
# opens output_nkonstan.tsv to be written to

while ($line = <GENELIST>) {
# read GENELIST file line by line
	@gene = split("\t", $line);
# information separated by tabs form elements in the @gene array
	$hash1{$gene[3]} = $gene[4];
}
# assign key $gene[3] to value $gene[4] in hash1. Key is fourth position of @gene array and value is fifth position of @gene array.

while ($line = <DIFFEXP>) {
# read DIFFEXP file line by line
@tsv = split("\t", $line);
# information separated by tabs form elements in the @tsv array
$hash2{$tsv[0]} = $tsv[4];
}
# assign key $tsv[0] to value $tsv[4] in hash2. Key is first position of @tsv array and value is fifth position of @tsv array.

@k = keys %hash1;
# makes the array @k = list of all keys in the hash

print OUTPUT "Gene Name\tDescription\tp-value\n";
# \t will separate Gene Name, Description and p-value by column

foreach $genename(@k) {
# $genename tells you what variable you are going to assign to each index of what is inside @k - at positions 0, 1, 2, 3, etc
	if ($hash2{$genename}) {
# checks if key from hash 1 accesses value in hash 2 (only occurs if gene name found in both files)
		print OUTPUT "$genename\t$hash1{$genename}\t$hash2{$genename}";
# prints gene name, prints description tied to gene name, prints p value tied to gene name
	}
}

close GENELIST; close DIFFEXP; close OUTPUT;
#closes the files containing the gene information and the output file
