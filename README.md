liftOverPlink
=============
This repository is forked from [sritchie73/liftOverPlink](https://github.com/sritchie73/liftOverPlink).

## Important changes

1. An option `-b` is added to allow using BIM file as input for liftOver.

2. A companion Perl script `updateLiftOverBim.pl` is provided to update BIM file following liftOver.

---
## Usage

```
usage: liftOverPlink.py [-h] -m MAPFILE [-p PEDFILE] [-d DATFILE] -o PREFIX -c
                        CHAINFILE [-e LIFTOVEREXECUTABLE]

liftOverPlink.py converts genotype data stored in plink's PED+MAP format from
one genome build to another, using liftOver.

optional arguments:
  -h, --help            show this help message and exit
  -m MAPFILE, --map MAPFILE
                        The plink MAP file to `liftOver`.
  -b                    If specified, MAP file is in BIM format.
  -p PEDFILE, --ped PEDFILE
                        Optionally remove "unlifted SNPs" from the plink PED
                        file after running `liftOver`.
  -d DATFILE, --dat DATFILE
                        Optionally remove "unlifted SNPs" from a data file
                        containing a list of SNPs (e.g. for --exclude or
                        --include in `plink`)
  -o PREFIX, --out PREFIX
                        The prefix to give to the output files.
  -c CHAINFILE, --chain CHAINFILE
                        The location of the chain file to provide to
                        `liftOver`.
  -e LIFTOVEREXECUTABLE, --bin LIFTOVEREXECUTABLE
                        The location of the `liftOver` executable.
```

## Companion Tools
```
usage: updateLiftOverBim.pl --bim|-b <old_bim_file> --map|-m <liftOver_new_map_file> --out|-o <output_bim_file>

updateLiftOverBim.pl updates variants information in BIM file following liftOver.

Arguments:
  --bim|-b              old BIM file to be updated.
  --map|-m              MAP file after liftOver as produced by liftOverPlink.py.
  --out|-o              output new BIM file.
```

