#!usr/bin/perl
# nuc_nkonstan.pl
use strict;
# makes you define variables as either local or global
use warnings;
# tells you what the problem is and the line in which it is located

my $DNA;
# declares the sequence string entered
my $UCDNA;
# declares the capitalized sequence string
my $char;
# declares the string that is being compared to the sequence to find stop and start codon positions
my $result=-1;
# declares the position of the start and stop codons
my @stop;
# declares the array that is being compared to the sequence to find stop codon positions
my @sequence;
# declares the array that $dna will be split into
my $a;
# declares the string which is checked against every element in the array @sequence
my $g_count=0;
# declares G count
my $c_count=0;
# declares C count
my $a_count=0;
# declares A count
my $t_count=0;
# declares T count
my $o_count=0;
# declares any other character count
my $length;
# declares length of entire sequence
my $Gper;
# declares percentage of G in the sequence
my $Cper;
# declares percentage of C in the sequence
my $Tper;
# declares percentage of T in the sequence
my $Aper;
# declares percentage of A in the sequence
my $Oper;
# declares percentage of other characters in the sequence
my $joined_string;
# declares the string that is produced after the @sequence array becomes a string again
my $RNA;
# declares the RNA string
my $rcDNA;
# declares the reverse complement of $DNA
my $rcRNA;
# declares the reverse complement of $DNA with every T changed to U (if the DNA sequence is a template strand)
my $answer;
# declares the answer entered

print "Enter a DNA sequence string:\n";
# prints "Enter a DNA sequence string:" to the terminal
$DNA = <STDIN>;
# allows you to input a sequence onto the terminal

chomp ($DNA);
# prevents the return key from being counted as a character in the terminal

print ("Your sequence: ");
# prints what is in quotation marks

print uc($DNA). "\n\n";
# converts the entered string to uppercase

if ($DNA =~ m/ATG/i) {
	$UCDNA = uc($DNA);
# capitalizes the DNA sequence
	$char = 'ATG';
	while ($result != 0) {
  		$result = index($UCDNA, $char, $result) + 1;
		if ($result != 0) {
			print "Putative start codon present at position $result.\n\n";
		}
	}
}
# if there is ATG in the sequence, print "Putative start codon present at position" and the positions of the start codons
else {
	print "Putative start codon not present.\n\n";
}
# if there is no ATG in the sequence, print "Putative start codon not present."
if ($DNA =~ m/TAA|TAG|TGA/i) {
	@stop = ("TAA","TAG","TGA");
	$UCDNA = uc($DNA);
# capitalizes the DNA sequence
	foreach $char(@stop) {
	$result = -1;
		while ($result != 0) {
			$result = index($UCDNA, $char, $result) + 1;
			if ($result != 0) {
				print "Putative stop codon present at position $result.\n\n";
			}
		}
	}
}
# if there is TAA, TAG or TGA in the sequence, print "Putative stop codon present" and the positions of the stop codons
else {
	print "Putative stop codons not present.\n\n";
}
# if there is no TAA, TAG or TGA in the sequence, print "Putative stop codons not present."

@sequence = split("", $DNA);
# splits the sequence string into an array storing one letter per array element

foreach my $a (@sequence) {
# go through the elements of the @sequence array and compare to $a in the if, elsifs and else
	if ($a =~ /G/i) {$g_count++}
# counts number of G
	elsif ($a =~ /C/i) {$c_count++}
# counts number of C
	elsif ($a =~ /T/i) {$t_count++}
# counts number of T
	elsif ($a =~ /A/i) {$a_count++}
# counts number of A
	else {$o_count++}
# counts number of other characters
}

$length = $#sequence + 1;
# defines $length as the number of characters in the sequence +1 to account for the 0 position

$Gper=($g_count/($length)*100);
# defines $Gper as the percentage of G in the sequence
$Cper=($c_count/($length)*100);
# defines $Cper as the percentage of C in the sequence
$Tper=($t_count/($length)*100);
# defines $Tper as the percentage of T in the sequence
$Aper=($a_count/($length)*100);
# defines $Aper as the percentage of A in the sequence
$Oper=($o_count/($length)*100);
# defines $Oper as the percentage of other characters in the sequence

printf("The sequence length is $length.\n\nBase\t     Count\tPercentage\t\nA\t%10d\t%3.4f%%\nG\t%10d\t%3.4f%%\nT\t%10d\t%3.4f%%\nC\t%10d\t%3.4f%%\nOther\t%10d\t%3.4f%%\n\n", $a_count,$Aper,$g_count,$Gper,$t_count,$Tper,$c_count,$Cper,$o_count,$Oper);
# prints the following in a formatted way: sequence length, G and g count, C and c count, T and t count, A and a count, other characters count, the fraction of G and g in percentage, the fraction of C and c in percentage, the graction of A and a in percentage, the fraction of any other character in percentage

push(@sequence, "AAAAAAAAAAAA");
# adds 12 A's to the end of the array

$joined_string = join("", @sequence);
# changes the array back into a string
print ("Sequence after polyadenylation with 12 adenines: ");
# prints the text within quotation marks

print uc("$joined_string\n\n");
# prints the sequence string in uppercase letters with with the 12 A's at the end

$rcDNA = reverse($DNA);
# defines $rcDNA as equal to the reverse of $DNA 
$rcDNA =~ tr/ACGT/TGCA/;
# in $rcDNA, TGCA is matched with ACGT in $DNA and ACGT is matched with TGCA in $DNA
print "Reverse complement is: ";
# prints what is in quotation marks
print uc("$rcDNA\n\n");

print "Is your sequence the coding strand?\n";
$answer = <STDIN>;
# allows you to input an answer onto the terminal

if ($answer =~ m/^Y/i)	{
	$RNA = $DNA;
	$RNA =~ s/T/U/g;
	$RNA =~ s/t/u/g;
	print "RNA sequence is: ";
	print uc("$RNA\n\n");
# if the answer anything starting with y (case insensitive), make all instances of T become U and t become u, and print what is in quotation marks
}
else {
	$rcRNA = reverse($DNA);
	$rcRNA =~ tr/ACGT/UGCA/;
	$rcRNA =~ s/T/U/g;
	$rcRNA =~ s/t/u/g;
	print "RNA sequence is: ";
	print uc("$rcRNA\n\n");
# if the answer is anything else (meaning template strand), the reverse complement RNA is found: $DNA is reversed, in $rcRNA, TGCA is matched with ACGT in $DNA and ACGT is matched with TGCA in $DNA, every T changed to U and every t changed to u, and print what is in quotation marks
}
