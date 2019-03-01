##this script reverse complement all seqs in a fasta file
#! /usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage; 
use Bio::Perl;

my $infile='';

my $message_text  = "please specify option parameters. -i < fasta file >";
  my $exit_status   = 2;          ## The exit status to use
  my $verbose_level = 0;          ## The verbose level to use
  my $filehandle    = \*STDERR;   ## The filehandle to write to
GetOptions ('i=s' => \$infile);
pod2usage( { -message => $message_text ,
               -exitval => $exit_status  ,  
               -verbose => $verbose_level,  
               -output  => $filehandle } ) if ($infile eq '');

my $infilename;
			   
if ($infile=~/\//)
{			   
$infile=~/.+\/(.+)/;
$infilename=$1;
}
else 
{
$infilename=$infile;
}

$infilename=~s/\.fasta//;
print $infilename."\n";			   
open OUT, ">$infilename.revcom.fasta";			  
my $seqio=Bio::SeqIO->new(-format => 'Fasta', -file=>"$infile");

while(my $seqobj=$seqio->next_seq)
{
	my $id=$seqobj->id;
	my $seq=$seqobj->seq;
			  
	my $revcom_seqobj = revcom( $seq );
	my $revcom_seq=$revcom_seqobj->seq();
	
	print OUT ">$id\n$revcom_seq\n";

}