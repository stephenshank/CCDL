Welcome to the CCDL Repo!! 

This will be a simple, and fun pipeline to run.

Currently this is a python script, but we will transform it into a snakemake script very soon!
I have it as a snakemake script but it is on a remote server.


you will need to grab the data from the slack channel and put it in the 
```rsrc``` folder, then:

```unzip rsrc/NB_cell_line.zip```

To start the pipeline: run these two scripts in order:

you should only need to run this script once

```python python/installer.py```

anytime you want to re-run the data, run this script

```python python/pipeline.py```
