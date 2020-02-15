import os
import pandas as pd


DATA_ROOT = os.environ.get('DATA_ROOT') or 'output_data'

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
    in_sf = "./ccdl_data/NB_cell_line/{SRA}/quant.sf"
  output:
    out_raw = "./output_data/{SRA}/{SRA}_RAW_txi.csv",
    out_LSTPM = "./output_data/{SRA}/{SRA}_LSTPM_txi.csv",
    out_STPM = "./output_data/{SRA}/{SRA}_STPM_txi.csv"
    #out_DSTPM = "../output_data/{SRA}/{SRA}_DSTPM_txi.csv",
  
  # output when we get DSTPM working
  #Rscript rscripts/sf_to_txi.R {input.in_sf} {output.out_raw} {output.out_LSTPM} {output.out_STPM} {output.DSTPM}
  shell:
    '''
    Rscript rscripts/sf_to_txi.R {input.in_sf} {output.out_raw} {output.out_LSTPM} {output.out_STPM}
    '''

rule get_metadata:
  output:
    f'{DATA_ROOT}/master-metadata.tsv'
  shell:
    'wget -O {output} http://stephenshank.com/master-metadata.tsv'

