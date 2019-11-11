import pandas as pd


## list of all the SRA's

my_file = pd.read_csv("rsrc/NB_cell_line_metadata_cleaned.tsv", sep="\t"))
SRAs = my_file.["Sample_SRR_accession"].to_list()

#rule targets:
#  input:
#    expand("data/{sra}/{sra}_txi.csv", sra=SRAs)




## this is just to run one, but will need to change to {SRAs} to capture all ##
######################################
# this rule will read in the .sf files
# and will run them thru Rscript txi
######################################
rule txi:
  input:
    in_sf = "rsrc/NB_cell_line/SRR4787043/quant.sf"
  output:
    out_f = "data/SRR4787043/SRR4787043_txi.tsv"
  shell:
    '''
    Rscript rscripts/sf_to_txi.R {input.in_sf} {output.out_f}
    '''

#####################################
# this rule will read in the .sf files
# and will run them thru some ML
######################################
#rule txi:
#  input:
#    in_sf = "rsrc/{sf}_quant.sf"
#  output:
#    out_f = "data/{sf}_txi.csv"
#  script:
#    "rscripts/sf_to_txi.R {input.in_sf} {output.out_f}"



