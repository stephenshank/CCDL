import pandas as pd
import subprocess


'''
before we go too far, we need the data.
here is a file that we will read in using
pandas and grab the first column of names
'''
data = pd.read_csv("rsrc/NB_cell_line_metadata_cleaned.tsv", sep="\t")

names = data["Sample_SRR_accession"].tolist()
#print(names)


'''
Adam wrote a nice R script that will:
    1. install all packages
    2. download any libraries we need
    3. get 4 out of our 5 output data-types for normalization
lets pass these files to the R script and let it run
'''

for name in names[0:1]:
    f_in = "rsrc/NB_cell_line/%s/quant.sf" % name
    f_out_raw = "data/%s/Raw_txi.csv" % name
    f_out_LSTPM = "data/%s/LSTPM_txi.csv" % name
    f_out_STPM = "data/%s/STPM_txi.csv" % name
    ## running into issues with this file ##
    f_out_DSTPM = "data/%s/DSTPM_txi.csv" % name

    subprocess.call("mkdir data/%s" % name, shell=True)
    subprocess.run("Rscript rscripts/sf_to_txi.R %s %s %s %s %s" % (f_in, f_out_raw,
        f_out_LSTPM, f_out_STPM, f_out_DSTPM), shell=True)

print("All done with the SRAs")






