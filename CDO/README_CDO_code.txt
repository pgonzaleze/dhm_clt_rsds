Author: Pedro González-Espinosa
The University of British Columbia
Date:Feb-11th-2021
Last edit: Feb-11th-2021

Climate Data Operators (CDO) used to generate files for Gonzalez-Espinosa and Donner Cloudiness and Heat-Stress on coral bleaching

## Syntaxis:
<infile.nc>: indicates the file where the data is taken
<outfile.nc>: indicates the file that is created after operators

## Examples of commands/operators you might need:

# Merge all files in a directory
cdo mergetime *.nc <outfile.nc>    # merge files into a single netCDF file
cdo mergetime sst_coraltemp_1985*.nc <outfile.nc>    #  This command would only select files from 1985

# Remap using billinear interpolation; specify the grid size
cdo remapbil,r360x180 ifile ofile   # 1° x 1°
cdo remapbil,r720x576 ifile ofile   # 0.5° x 0.5°

# Alternativey if you want two match two files with different grid, you can use 'remapcon' operator 
cdo remapcon,base_file ifile ofile   # change the grid according to the "base_file".   

Compute anomaly
cdo -z zip sub monmean_ifile(obs) ymonmean_ifile(clim) ofile 
cdo ymonmean -runmean,n ifile ofile









