#!/usr/bin/perl -w
use strict;
use Getopt::Long;
#Perl script to update plink BIM file after liftOver. This is only for handling human data.
#Author: Minghui Wang (m.h.wang@live.com)
#

my ($outfile, $bimFile, $newMapFile);
my $EXE = $0;
sub usage{
        my ($EXE)=@_;
        print STDERR "Usage:\tperl $EXE --bim|-b <old_bim_file> --map|-m <liftOver_new_map_file> --out|-o <output_bim_file>\n\n";
        print STDERR "  --bim|-b, old BIM file to be updated.\n";
        print STDERR "  --map|-m, MAP file after liftOver as produced by liftOverPlink.py.\n";
        print STDERR "  --out|-o, output new BIM file.\n";
        exit 0;
}

GetOptions ("out|o=s" => \$outfile,
            "map|m=s" => \$newMapFile,
            "bim|b=s" => \$bimFile ) or usage($EXE);


usage($EXE) if(! defined $outfile);
usage($EXE) if(! defined $newMapFile);
usage($EXE) if(! defined $bimFile);
#
print "Read $newMapFile...\n";
open(FM, "<$newMapFile") or die $!;
my %maps;
my %skips;
my $nskip = 0;
while(<FM>){
        chomp;
        my $s = $_;
        my @arr=split(/\s+/, $_);
        if($arr[0] eq 'X' || $arr[0] eq 'x'){
            $arr[0] = 23;
        }elsif ($arr[0] eq 'Y' || $arr[0] eq 'y'){
            $arr[0] = 24;
        }elsif($arr[0] eq 'MT' || $arr[0] eq 'Mt'  || $arr[0] eq 'mt'){
            $arr[0] = 25;
        }elsif($arr[0] !~ /^\d+$/){
            $skips{$arr[0]} ++;
            $nskip ++;
            next;
        }
        $maps{$arr[1]}{'s'} = $s;
        $maps{$arr[1]}{"chr"} = $arr[0];
        $maps{$arr[1]}{"pos"} = $arr[3];
}
close(FM);
if($nskip > 0){
    print STDERR "$nskip SNPs from contig scaffolds are discarded.\n";
}
print "Read $bimFile...\n";
open(FB, '<', $bimFile) or die $!;
my %bims;
while(<FB>){
        chomp;
        if(/\S+\s+(\S+)\s+\S+\s+\S+(\s+\S+\s+\S+)/){
            if(exists($maps{$1})){
                $maps{$1}{'s'} = $maps{$1}{'s'}.$2;
            }
        }
}
close(FB);

my @mkeys = sort { $maps{$a}{"chr"} <=> $maps{$b}{"chr"} or $maps{$a}{"pos"} <=> $maps{$b}{"pos"} } keys(%maps);

print "Write to $outfile...\n";
open(FO, '>', $outfile) or die $!;
foreach (@mkeys){
        print FO "$maps{$_}{'s'}\n";
}
close(FO);
