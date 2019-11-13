Welcome to the CCDL Repo!! 

This will be a simple, and fun pipeline to run.

To begin, start up your conda virtual environment:

```conda env create -f environment.yml ```

```conda activate ccdl``` or ```source activate ccdl```

quickly run this to gather the data:

```bash bash/getter.sh```

When you want to deactivate your environment, simply type:
```conda deactivate``` or ```source deactivate``` 

The [conda docs](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) are super helpful!

Now you are ready to begin!

Next, you will need to grab the data from the slack channel and put it in the 
```rsrc``` folder, then:

```unzip rsrc/NB_cell_line.zip```

To start the pipeline: run these two scripts in order:

you should only need to run this script once

```python python/installer.py```

anytime you want to re-run the data, run this script

```python python/pipeline.py```
