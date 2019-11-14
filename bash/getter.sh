#!/bin/bash


wget http://stephenshank.com/ccdl_data.zip || (curl http://stephenshank.com/ccdl_data.zip && exit 1)

#if wget http://stephenshank.com/ccdl_data.zip; then
#  echo Gathered the data!
#else
#  curl http://stephenshank.com/ccdl_data.zip
#fi

unzip ccdl_data.zip

unzip ccdl_data/NB_cell_line.zip

mv NB_cell_line ccdl_data/

rm ccdl_data.zip
rm -rf NB_cell_line


