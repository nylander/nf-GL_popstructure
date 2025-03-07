# nf-GL_popstructure

[Nextflow](https://www.nextflow.io/) pipeline that calculates genotype
likelihoods in [ANGSD](https://github.com/ANGSD/angsd) from a list of bam files,
admixture through [NGSadmix](https://github.com/aalbrechtsen/NGSadmix) and
PCAs through [PCAngsd](https://github.com/Rosemeis/pcangsd).

**Note** The workflow requires a nextflow version that can run
[dsl1](https://www.nextflow.io/docs/latest/dsl1.html).

v2.0 includes pseudo-linkage pruning (by thinning) and a speed-optimization update.

(**TODO**: More description here of the actual workflow (repeated k's, repeated runs, etc).

## Quick start

(**TODO**: Update install instructions in a file [INSTALL] and in the conda [enviroment.yml](enviroment.yml) files.)

1. Install prerequisites. See file [INSTALL](INSTALL).

2. Download or git clone this repository:

        $ git clone https://github.com/FilipThorn/nf-GL_popstructure

3. Prepare input files ([see below](#input-files))

4. Run the nextflow pipeline (**Note**: needs a nextflow version that can run
   dsl1. See file[INSTALL](INSTALL)).

        $ nextflow run main.nf \
            --bamlist_tsv sample.tsv \
            --outdir outfolder \
            --chr_ref chr.list

## Input files

1. `sample.tsv`: Tab separated file with three columns: `name`: named set of
   bam files to analyze, `subset`: file with absolute paths to bam files in the
   named set, `ancestral`: a number `n` (integer) with starting number of
   ancestral populations (`k`). Analyses will be repeated with
   `k={n-2,n-1,n,n+1,n+2}`.

        name    subset  ancestral
        SUBSET1 /path/to/SUBSET1/bam.list n
        SUBSET2 /path/to/SUBSET2/bam.list n

2.  `bam.list`: File with absolute paths to bam files in the set(s) defined in `sample.tsv`

        /path/to/IndvXXXX/IndvXXXX_sorted.bam
        /path/to/IndvXXXX/IndvXXXX_sorted.bam
        /path/to/IndvXXXXIndvXXXX_sorted.bam
        /path/to/IndvXXXX/IndvXXXX_sorted.bam

3. `chr.list`: Subset of chromosomes or scaffolds present in your bam files. Example:

        chr1
        chr2
        chr3
        chr4
        chr5

## Output files

(**TODO**: describe the output files)

## Plotting the output

For plotting the output, we highly recommend pong
(<https://github.com/ramachandran-lab/pong>).

(**TODO**: add a worked example on using pong)

## HPC environment

Use of a HPC is highly recommended. Create a nextflow config profile that
matches your cluster set-up [`profile`](https://www.nextflow.io/docs/latest/config.html#config-profiles)
and add it in the folder `profile/` and to the [`nextflow.config`](nextflow.config).

### Example running on [Dardel](https://www.pdc.kth.se/hpc-services/computing-systems/dardel-hpc-system)

(**TODO**: finish these instructions)

    $ ml PDC/23.12 java/17.0.4 singularity python/3.12.3 bioinfo-tools NextFlow/22.10.1
    $ export NXF_OPTS='-Xms1g -Xmx4g'
    $ export NXF_CONDA_CACHEDIR=/cfs/klemming/projects/supr/path/to/NXF_CONDA_CACHEDIR
    $ export NXF_SINGULARITY_CACHEDIR=/cfs/klemming/projects/supr/path/to/NXF_SINGULARITY_CACHEDIR
    $ mkdir -p $SNIC_TMP/nf-GL_popstructure/work
    $ nextflow run \
        -w $SNIC_TMP/nf-GL_popstructure/work \
        ./main.nf \
        -name GL_popstructure \
        -with-report GL_popstructure.html \
        -profile dardel \
        --project projid
