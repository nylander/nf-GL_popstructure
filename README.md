# nf-GL_popstructure

Nextflow pipeline that calculates genotype likelihoods in
[angsd](http://www.popgen.dk/angsd/index.php/ANGSD) from a list of bamfiles and
plots admixture through
[NGSadmix](http://www.popgen.dk/software/index.php/NgsAdmix), and PCAs through
[PCAngsd](https://github.com/Rosemeis/pcangsd).

## Quick start

1) Install [`nextflow`](https://www.nextflow.io/) (version >= 19.04)

2) Install [`Conda`](https://conda.io/miniconda.html) (version >= 4.10) 

3) Download git clone of this repository:

        git clone https://github.com/FilipThorn/nf-GL_popstructure

4) Download and install PCAngsd from
[https://github.com/Rosemeis/pcangsd](https://github.com/Rosemeis/pcangsd)

5) Run the nextflow pipeline:

       nextflow run GL_popstr.nf \
           --bams /PATH/TO/BAMFILELIST/'*.list' \
           --outdir /PATH/TO/RESULTS/ \
           --chr_ref /PATH/TO/CHRSOMELIST

## Input files

#### 1.  bam file list example: 
    
    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam 
    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam 
    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam 
    /Absolute/PATH/IndvXXXX/IndvXXXX_sorted.bam 

**Note**: Labels in plots are based on the subdirectory name. Example:
    
/results/**Indv0001**/Indv0001\_sorted.bam 
    
If you have a different file structure you can run the pipeline with the flag
`--skip_plots true` and create plots on your own.
    
#### 2. chromosome reference file example (subset of scaffolds present in your bamfiles):
  
    chr1
    chr2
    chr3
    chr4
    chr5 
 
## HPC environment

Use of a HPC is recommended. Create a nextflow config profile that matches your
cluster set-up [`profile`](
https://www.nextflow.io/docs/latest/config.html#config-profiles)
 

  
