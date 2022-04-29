# nf-GL_popstructure

Nextflow pipeline that calculates genotype likelihoods in
[angsd](http://www.popgen.dk/angsd/index.php/ANGSD) from a list of bamfiles and
plots admixture through
[NGSadmix](http://www.popgen.dk/software/index.php/NgsAdmix), and PCAs through
[PCAngsd](https://github.com/Rosemeis/pcangsd).


## Installation

Execution of this package requires python, nextflow, and conda.  In addition,
[PCAngsd](https://github.com/Rosemeis/pcangsd) needs to be installed. See the
[INSTALL](INSTALL) file for details.

## Settings

Edit the run-specific parameter settings in
[`nextflow.config`](nextflow.config).  Memory requirements and CPU settings can
be changed in [`conf/local.config`](conf/local.config).

## Run

    $ nextflow run /path/to/nf-GL_popstructure \
        -profile local \
        --bams bam.list \
        --chr_ref chromosomes.txt \
        --outdir results

## Input files

#### 1. File `bam.list` example:

    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam
    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam
    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam
    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam

**Note 1**: the file with a list of bam files needs to end in `.list`.

**Note 2**: bam files needs to be indexed (i.e., index files, `.bai`, needs to
be present!).

**Note 3**: Labels in plots are based on the subdirectory name. Example:

/results/**Indv0001**/Indv0001\_sorted.bam

If you have a different file structure you can run the pipeline with the flag
`--skip_plots true` and create plots on your own.

#### 2. Chromosome reference file example (subset of scaffolds present in your bam files):

    chr1
    chr2
    chr3
    chr4
    chr5

## HPC environment

Use of a HPC is recommended. Create a nextflow config profile that matches your
cluster set-up. See, e.g. [nextflow.io/docs/latest/config.html](
https://www.nextflow.io/docs/latest/config.html#config-profiles)

