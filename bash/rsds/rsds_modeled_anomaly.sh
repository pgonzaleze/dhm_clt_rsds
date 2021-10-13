#!/bin/bash
# Compute the modeled cloud anomaly 
# Compute climatology for the period 1985-2004 
for file in GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc
do
echo i$
for file in "ls GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc"
do

# First, subset the years 1985-2100 to compute the final anomaly
cdo -z zip -selyear,1985/2100 GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_1985-2100.nc

# Compute the long-term climatology (fixed period 1985-2004)
cdo -z zip ymonmean -selyear,1985/2004 GFDL-ESM4_ssp126_rsds_Amon_Bcor.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_ymonmean.nc 

# Compute the anomaly (data-climatology)
cdo sub -selmonth,1/12 GFDL-ESM4_ssp126_rsds_Amon_Bcor_1985-2100.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_ymonmean.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom.nc 

done
done