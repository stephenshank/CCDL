import pandas as pd
import os
import json

## list of all the SRA's
my_file = pd.read_csv("rsrc/NB_cell_line_metadata_cleaned.tsv", sep="\t")
SRAs = my_file["Sample_SRR_accession"].to_list()




rule targets:
  input:
    expand("output_data/{SRA}/{SRA}_RAW_txi.csv", SRA=SRAs),
    expand("output_data/{SRA}/{SRA}_LSTPM_txi.csv", SRA=SRAs),
    expand("output_data/{SRA}/{SRA}_STPM_txi.csv", SRA=SRAs)


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
    in_sf = "ccdl_data/{SRA}/quant.sf"
  output:
    out_raw = "output_data/{SRA}/{SRA}_RAW_txi.csv",
    out_LSTPM = "output_data/{SRA}/{SRA}_LSTPM_txi.csv",
    out_STPM = "output_data/{SRA}/{SRA}_STPM_txi.csv"
    #out_DSTPM = "../output_data/{SRA}/{SRA}_DSTPM_txi.csv",
  
  # output when we get DSTPM working
  #Rscript rscripts/sf_to_txi.R {input.in_sf} {output.out_raw} {output.out_LSTPM} {output.out_STPM} {output.DSTPM}
  shell:
    '''
    Rscript rscripts/sf_to_txi.R {input.in_sf} {output.out_raw} {output.out_LSTPM} {output.out_STPM}
    '''


DATA_ROOT = '/data/shares/ccdl'
rule bigcrunch:
  output:
    "output_data/id_pairs.json"
  run:
    pairs = []
    base_directories = [
      directory
      for directory in os.listdir(DATA_ROOT)
      if directory[0] in ['E', 'S']
    ]
    for base_directory in base_directories:
      fullpath = DATA_ROOT + '/' + base_directory
      sf_files = [
        a_file.split('_')[0]
        for a_file in os.listdir(fullpath)
        if a_file.split('.')[-1] == 'sf'
      ]
      for sf_file in sf_files:
        pairs.append([base_directory, sf_file])
    with open(output[0], 'w') as json_file:
      json.dump(pairs, json_file, indent=2)

