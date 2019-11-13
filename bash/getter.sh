#!/bin/bash


wget http://stephenshank.com/ccdl_data.zip

unzip ccdl_data.zip

unzip ccdl_data/NB_cell_line.zip

mv NB_cell_line ccdl_data/

rm ccdl_data.zip



