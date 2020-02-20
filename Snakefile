import os
import pandas as pd


DATA_ROOT = os.environ.get('DATA_ROOT') or 'output_data'

def f(path):
  return DATA_ROOT + '/' + path

## list of all the SRA's
my_file = pd.read_csv("rsrc/NB_cell_line_metadata_cleaned.tsv", sep="\t")
SRAs = my_file["Sample_SRR_accession"].to_list()




rule targets:
  input:
    expand("./output_data/{SRA}/{SRA}_RAW_txi.csv", SRA=SRAs),
    expand("./output_data/{SRA}/{SRA}_LSTPM_txi.csv", SRA=SRAs),
    expand("./output_data/{SRA}/{SRA}_STPM_txi.csv", SRA=SRAs)


######################################
# this rule will read in the metadata tsv
# and will get all the data from Stepens website
######################################
rule get_data:
  shell:
    '''
    bash bash/getter.sh
    '''
 
######################################
# this rule will read in the .sf files
# and will run them thru Rscript txi
######################################
rule txi:
  input:
    sf=f('{SRP}/{SRR}_quant.sf')
  output:
    raw=f('{SRP}/{SRR}_RAW_txi.csv'),
    LSTPM=f('{SRP}/{SRR}_LSTPM_txi.csv'),
    STPM=f('{SRP}/{SRR}_STPM_txi.csv')
  
  # output when we get DSTPM working
  #Rscript rscripts/sf_to_txi.R {input.in_sf} {output.out_raw} {output.out_LSTPM} {output.out_STPM} {output.DSTPM}
  shell:
    '''
    Rscript rscripts/sf_to_txi.R {input.sf} {output.raw} {output.LSTPM} {output.STPM}
    '''

rule get_metadata:
  output:
    f'{DATA_ROOT}/master-metadata.tsv'
  shell:
    'wget -O {output} http://stephenshank.com/master-metadata.tsv'

rule get_subset_tarball:
  output:
    f'{DATA_ROOT}/ccdl_data_v3.tar.gz'
  shell:
    'wget -O {output} http://stephenshank.com/ccdl_data_v3.tar.gz'

rule decompress_subset:
  input:
    rules.get_subset_tarball.output[0]
  shell:
    f'tar xvzf {input} -C {DATA_ROOT}'
