#! /usr/bin/perl
$|++;
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage; 
use Bio::Perl;
use Bio::Seq;
use Bio::SeqIO;
use Bio::AlignIO;
use Bio::LocatableSeq;
use Bio::SearchIO;
use List::Util qw[min max];
sub loopthroughhspNmerge();
my $file='';

my $message_text  = "please specify option parameters. -i <blastout file> ";
  my $exit_status   = 2;          ## The exit status to use
  my $verbose_level = 0;          ## The verbose level to use
  my $filehandle    = \*STDERR;   ## The filehandle to write to
GetOptions ('i=s' => \$file);
pod2usage( { -message => $message_text ,
               -exitval => $exit_status  ,  
               -verbose => $verbose_level,  
               -output  => $filehandle } ) if ($file eq '' );

open OUT, ">$file.parsed" or die; # open file to store result
print OUT "Match_ID\tCoverage\tPercent identity";
##########################################################################################
######parsing the blastout file and print out hsps with coverage and identity above cutoff
##########################################################################################
my $in = new Bio::SearchIO(-format => 'blast', 
                           -file   => "$file");                          

while( my $result = $in->next_result ) {

my $q_len = $result->query_length;
my $queryname = $result->query_name;
#print "result: ".$queryname."\n";

	while(my $hit = $result->next_hit) {

			my $hitname=$hit->name;
			my $hitdesc=$hit->description;
			#print "hit: ".$hitname."\n";
					 
		while( my $hsp = $hit->next_hsp) { 

				my $hspstrand=$hsp->strand('hit');
				my $hspstart=$hsp->start('hit');
				my $hspend=$hsp->end('hit');
				my $hsplength=$hsp->hsp_length();				
				my $percid=$hsp->percent_identity();
				my $coverage=$hsplength/$q_len;
				if ($coverage>=0.55 and $percid>=75)
				{
					print OUT "$hitname\t$coverage\t$percid\n";
				}
		}
}
}
