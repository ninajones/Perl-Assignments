package GTFnkonstan;
use strict;
use warnings;

### Header:
# Subroutines called upon from gtf_nkonstan.pl are stored in this file.
# These subroutines open genes.gtf, reads portions using regex, count 
# the number of genes, count the number of exons, calculate the average
# exon length, and identify the gene with the highest number of exons.
# File created: 23/4/2017. File last modified: 23/4/17.

### This prints information about what each flag represents.
sub help {
	print ("You have selected -h (help).\n");
	print ("-g counts the number of genes in the gtf file.\n");
	print ("-e counts the number of exons in the gtf file.\n");
	print ("-a calculates the average exon length.\n");
	print ("-n identifies the gene with the highest numbers of exons.\n");
}

### This subroutine counts the number of genes.
sub gene {
	### Initialises the variables
	my %geneID=();
	my $id;
	my $counter;
	open(GTFFILE, "$_[0]") or die ("error");
	while(<GTFFILE>){
		### Regex match for gene IDs
		if ($_ =~ /gene\wid\s\"(\S*)\"\;/) {
			### If unique gene ID found, increment total counter
			$id = $1;
			unless($geneID{$id}) {
				$geneID{$id} = 1;			
				$counter++;
			}
		}
	}
	print ("There are $counter genes.\n");
	close (GTFFILE);

}


### This subroutine counts the number of exons.
sub exons {

	### Initialises the variables
	my $id;
	my $counter;
	open(GTFFILE, "$_[0]") or die ("error");
	while(<GTFFILE>){
		### Regex match for exons
		if ($_ =~ /exon+\s+\d+\s+\d+\s+.+/) {
			### If exon found, increment total counter
			$id = $1;	
			$counter++;
			
		}
	}
	print ("There are $counter exons.\n");
	close (GTFFILE);

}

### This subroutine calculates the average exon length.
sub avg {

### Initialises the variables
	my %avgID=();
	my $avg;
	my $length1;
	my $length2;
	my $counter = 0;
	my $diff;
	my $total = 0;

	open(GTFFILE, "$_[0]") or die ("error");
	while(<GTFFILE>){
		### Regex match for exons
		if ($_ =~ /exon+\s+(\d+)\s+(\d+)\s+.+/) {
			$length1 = $1;
			$length2 = $2;
			### Calculate length of exon
			$diff = $length2 - $length1;
			$counter++;		
			### Places length of exon into a hash
			$avgID{$counter} = $diff;	

		}
	}
	### Sum all lengths from hash
	foreach my $len (values %avgID) {
		$total += $len; }
		### Calculate mean of length
		$avg = $total/$counter;

	print ("The average exon length is $avg.\n");
	close (GTFFILE);

}

### This subroutine identifies the gene with the highest number of exons.
sub mostexons {

### Initialises the variables
	my %mostexons;
	my $gene;
	my $counter = 0;


	open(GTFFILE, "$_[0]") or die ("error");
	while(<GTFFILE>){
		### Regex match for gene IDs and exons
		if ($_ =~ /exon\s+(\d+)\s+(\d+)\s\W\s+\W\s+\W\s+\/gene_id\s\"(\S+)\"/) {
			$gene = $3;
			### If $gene doesn't exist as key in the hash
			unless ($mostexons{$gene}) {
					$mostexons{$gene} = 1;
			}
			### If $gene does exist as a key in the hash, increment counter by 1
			else {
				$mostexons{$gene}++;
			} 		
		}
	}

	print ("The gene with the highest number of exons is $gene.\n");
	close (GTFFILE);
	
}

1;
