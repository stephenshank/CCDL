Welcome to the CCDL Repo!! 

This will be a simple, and fun pipeline to run.

To begin, start up your conda virtual environment:

```conda env create -f environment.yml ```

```conda activate ccdl``` or ```source activate ccdl```

To run the pipeline:

```snakemake get_data``` then 
```snakemake targets -j 100```

This might take some time, and a lot of memory, so be patient

When you want to deactivate your environment, simply type:
```conda deactivate``` or ```source deactivate``` 

The [conda docs](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) are super helpful!



