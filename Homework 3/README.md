# The script bioperl_nkonstan.pl does the following:

# 1. Reads a FASTA protein sequence from file (P11802.fasta) and use this sequence for a standalone BLAST search against uniprot_sprot.fasta.
# 2. Parse the BLAST output and for the top ten hits print sequence identifier, score, Expect-value and percent sequence identity (that is between Query and Hit) into a file called “hits.txt”. 
# 3. Retrieve the sequences for the top ten hits and write them out in a multiFASTA file “hits.fasta”. 
# 4. Align these sequences using muscle and store the alignment in clustalw format as “hits.aln”.
# 5. Open “hits.aln” in ClustalX.

# P11802.fasta is found here: http://www.uniprot.org/uniprot/P11802
# uniprot_sprot.fasta is found here: http://www.uniprot.org/downloads
