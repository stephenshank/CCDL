# external modules
import pandas as pd
# builtins for handling paths
import os
from pathlib import Path
# builtins for concurrency
from concurrent.futures import ProcessPoolExecutor
from functools import partial


"""
Probably not worth using unless there are A LOT of files, since in the test set the most
of the time was spent actually outputting the final CSV rather than combining 
This can perhaps be modified so that all types are done in parallel.
"""
# takes target_directory as a Path object, desired types as a list of numbers corresponding to
# tximport types to analyze
def parallelize(num_processors, target_directory, desired_types):
    types = {0: "RAW", 1: "LSTPM", 2: "STPM", 3: "DSTPM"}
    sub_direcs = os.listdir(str(target_directory))
    split = int(len(sub_direcs)/num_processors)
    subdirectory_work_list = list()
    for i in range(num_processors - 1):
        start = i * split
        end = (i + 1) * split
        subdirectory_work_list.append(sub_direcs[start:end])
    subdirectory_work_list.append(sub_direcs[(num_processors - 1) * split:])
    for typ in desired_types:
        cur_type = types[typ]
        to_call = partial(matrix_by_type, cur_type)
        with ProcessPoolExecutor(max_workers=num_processors) as executor:
            data = executor.map(to_call, subdirectory_work_list)
            data = pd.concat(data)
            out_path = Path(f"{target_directory}/{cur_type}_txi.csv")
            data.to_csv(str(out_path))


# takes target_directory as a Path object, desired types as a list of numbers corresponding to
# tximport types to analyze
def serial(target_directory, desired_types):
    types = {0: "RAW", 1: "LSTPM", 2: "STPM", 3: "DSTPM"}
    sub_direcs = os.listdir(str(target_directory))
    for typ in desired_types:
        cur_type = types[typ]
        data = matrix_by_type(cur_type, sub_direcs)
        out_path = Path(f"{target_directory}/{cur_type}_txi.csv")
        data.to_csv(str(out_path))


# takes type as a string corresponding to the desired tximport type and directory list
# is a list of strings that are the directories to be processed
def matrix_by_type(typ, directory_list):
    data_list = list()
    for direc in directory_list:
        dir_path = Path(f"{path}/{direc}")
        if dir_path.is_dir():
            file_path = Path(f"{str(dir_path)}/" + f"{direc}_{typ}_txi.csv")
            cur = pd.read_csv(str(file_path))
            cur.rename(columns={"Unnamed: 0": f"{direc}"}, inplace=True)
            cur.drop(columns=["abundance", "length"], inplace=True)
            cur = cur.transpose()
            data_list.append(cur)
    data = pd.concat(data_list)
    return data


# test things
if __name__ == '__main__':
    path = Path("./output_data/")
    #parallelize(4, path, [0, 1, 2])
    serial(path, [0, 1, 2])


