#!/bin/bash
# Perform a SST bias correction using simple delta change 
# The "CoralTemp" file was previously procesed to match grids using CDO 'remapcon' operator. 
for file in GFDL-ESM4_ssp126_tos_Omon.nc
do
echo i$
for file in "ls GFDL-ESM4_ssp126_tos_Omon.nc"
do

# compute model climatology for base period 1985-2004
cdo -z zip -ymonmean -selyear,1985/2004 GFDL-ESM4_ssp126_tos_Omon.nc GFDL-ESM4_ssp126_tos_climatology.nc
# subtract the climatology to the model projection 
cdo -z zip sub GFDL-ESM4_ssp126_tos_Omon.nc GFDL-ESM4_ssp126_tos_climatology.nc GFDL-ESM4_ssp126_tos_Omon_sub.nc
# Add the observed climatology to the bias correction
cdo -z zip add GFDL-ESM4_ssp126_tos_Omon_sub.nc coraltemp_climatology_remapcon_1985-2004.nc GFDL-ESM4_ssp126_tos_Omon_Bcor.nc
 
 done 
 done