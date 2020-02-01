import csv
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


#DATA_ROOT = '/home/sshank/ccdl/'
DATA_ROOT = '/data/shares/ccdl/'
rule bigcrunch:
  output:
    DATA_ROOT + "output_data/id_pairs.csv"
  run:
    csv_file = open(output[0], 'w')
    writer = csv.writer(csv_file)
    writer.writerow(('study_id', 'sample_id'))
    pairs = []
    base_directories = [
      directory
      for directory in os.listdir(DATA_ROOT)
      if not '.' in directory
    ]
    for base_directory in base_directories:
      fullpath = DATA_ROOT + '/' + base_directory
      sf_files = [
        a_file.split('_')[0]
        for a_file in os.listdir(fullpath)
        if a_file.split('.')[-1] == 'sf'
      ]
      for sf_file in sf_files:
        writer.writerow((base_directory, sf_file))
    csv_file.close()

rule txi_bigcrunch:
  input:
    sf=DATA_ROOT + "{folder}/{sfid}_quant.sf"
  output:
    raw=DATA_ROOT + "{folder}/{sfid}_raw.csv",
    lstpm=DATA_ROOT + "{folder}/{sfid}_lstpm.csv",
    stpm=DATA_ROOT + "{folder}/{sfid}_stpm.csv"
  shell:
    '''
    Rscript rscripts/sf_to_txi.R {input.sf} {output.raw} {output.lstpm} {output.stpm}
    '''

def full_bigcrunch_input(wildcards):
  with open('output_data/id_pairs.json') as json_file:
    pairs = json.load(json_file)[5:10]
  raw = [DATA_ROOT + "%s/%s_raw.csv" % tuple(pair) for pair in pairs]
  lstpm = [DATA_ROOT + "%s/%s_lstpm.csv" % tuple(pair) for pair in pairs]
  stpm = [DATA_ROOT + "%s/%s_stpm.csv" % tuple(pair) for pair in pairs]
  return raw + lstpm + stpm


rule full_bigcrunch:
  input:
    full_bigcrunch_input
