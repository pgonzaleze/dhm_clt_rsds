#!/bin/bash
# Compute the observed RSDS anomaly 
# Compute climatology for the period 2001-2017  
for file in CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_200003-202011.nc
do
echo i$
for file in "ls CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_200003-202011.nc"
do
# First, subset the years 2001-2017 to compute the final "anomaly"
cdo -z zip -selyear,2001/2017 CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_200003-202011.nc CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_2001-2017.nc

# Compute the long-term climatology (fixed period 2001-2017)
cdo -z zip ymonmean -selyear,2001/2017 CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_200003-202011.nc CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_ymonmean.nc 

# Compute the anomaly (data-climatology)
cdo sub -selmonth,1/12 CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_2001-2017.nc CERES_EBAF-sfc_sw_down_all_Ed4.1_Subset_ymonmean.nc CERES_EBAF-sfc_sw_down_anom.nc 

done
done