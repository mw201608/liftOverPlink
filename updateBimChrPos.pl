#!/usr/bin/perl -w
use strict;
use Getopt::Long;
#Perl script to update chromosome and pos in a BIM file based on a reference BIM.
#Author: Minghui Wang (m.h.wang@live.com)
#

my ($outfile, $inputBim, $refBim);
my $EXE = $0;
sub usage{
        my ($EXE)=@_;
        print STDERR "Usage:\tperl $EXE --bim|-b <input_bim_file> --ref|-r <reference_bim_file> --out|-o <output_bim_file>\n\n";
        print STDERR "  --bim|-b, input BIM file to be updated.\n";
        print STDERR "  --ref|-r, referene BIM file containing the new chromosome and position information.\n";
        print STDERR "  --out|-o, output new BIM file.\n";
        exit 0;
}

GetOptions ("out|o=s" => \$outfile,
            "ref|r=s" => \$refBim,
            "bim|b=s" => \$inputBim ) or usage($EXE);


usage($EXE) if(! defined $outfile);
usage($EXE) if(! defined $refBim);
usage($EXE) if(! defined $inputBim);
#
print "Read $refBim...\n";
open(FR, "<$refBim") or die $!;
my %maps;
while(<FR>){
        chomp;
        my $s = $_;
        my @arr=split(/\s+/, $_);
        $maps{$arr[1]}{"chr"} = $arr[0];
        $maps{$arr[1]}{"cm"} = $arr[2];
        $maps{$arr[1]}{"pos"} = $arr[3];
}
close(FR);

print "Process $inputBim...\n";
open(FB, '<', $inputBim) or die $!;
open(FO, '>', $outfile) or die $!;
while(<FB>){
        chomp;
        if(/(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+\S+\s+\S+)/){
            if(exists($maps{$3})){
                print FO "$maps{$3}{'chr'}$2$3$4$maps{$3}{'cm'}$6$maps{$3}{'pos'}$8\n";
            }else{
                die "Variant $maps{$3} present in the input BIM is absent in the reference BIM\n";
            }
        }
}
close(FB);
close(FO);
