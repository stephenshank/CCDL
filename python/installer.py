import subprocess


'''
this will just install the R packages we need
but we do not need to do this everytime, so we will
only do it one time in the beginning
'''

subprocess.run("Rscript rscripts/installer.R", shell=True)
