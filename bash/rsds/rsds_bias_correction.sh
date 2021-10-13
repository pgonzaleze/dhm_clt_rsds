#!/bin/bash
# Perform bias correction using simple delta change
for file in GFDL-ESM4_ssp126_rsds_Amon.nc
do
echo i$
for file in "ls GFDL-ESM4_ssp126_rsds_Amon.nc"
do

# compute model climatology for base period 2001-2014
cdo -z zip -ymonmean -selyear,2001/2014 GFDL-ESM4_ssp126_rsds_Amon.nc GFDL-ESM4_ssp126_rsds_climatology.nc

# subtract the climatology to the model projection 
cdo -z zip sub GFDL-ESM4_ssp126_rsds_Amon.nc GFDL-ESM4_ssp126_rsds_climatology.nc GFDL-ESM4_ssp126_rsds_Amon_sub.nc

# compute observed climatology
cdo -z zip -ymonmean CERES_EBAF-sfc_sw_down_all_Ed4.1_2001-2014.nc CERES_EBAF-sfc_sw_down_all_Ed4.1_climatology.nc

# match grids 
cdo -z zip remapcon,CERES_EBAF-sfc_sw_down_all_Ed4.1_climatology.nc GFDL-ESM4_ssp126_rsds_Amon_sub.nc GFDL-ESM4_ssp126_rsds_Amon_sub_rmap.nc

# Add the observed climatology to the bias correction
cdo -z zip9 add GFDL-ESM4_ssp126_rsds_Amon_sub_rmap.nc CERES_EBAF-sfc_sw_down_all_Ed4.1_climatology.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc

# Make file smaller
ncks --ppc "default"=".1" GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_ncks.nc

rm GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc
mv GFDL-ESM4_ssp126_rsds_Amon_Bcor_ncks.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc

done 
done