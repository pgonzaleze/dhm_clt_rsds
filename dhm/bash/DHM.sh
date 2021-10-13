#!/bin/bash
# Compute the Degree Heating Month index 
for file in GFDL-ESM4_ssp126_tos_Omon_Bcor.nc
do
echo i$
for file in "ls GFDL-ESM4_ssp126_tos_Omon_Bcor.nc"
do

# Compute the SST anomaly 

# Compute the monthly mean for the period 1985-2004
cdo -z zip ymonmean -selyear,1985/2004 GFDL-ESM4_ssp126_tos_Omon_Bcor.nc GFDL-ESM4_ssp126_tos_Omon_ymonmean.nc 

# Extract the maximum monthly mean 
cdo -z zip yearmax GFDL-ESM4_ssp126_tos_Omon_ymonmean.nc GFDL-ESM4_ssp126_tos_Omon_yearmax.nc

# Subset and compute the anomaly (difference between monthly values and maximum monthly mean)
cdo -z zip sub -selyear,1985/2100 GFDL-ESM4_ssp126_tos_Omon_Bcor.nc GFDL-ESM4_ssp126_tos_Omon_yearmax.nc GFDL-ESM4_ssp126_tos_Omon_ALL_anom.nc

# Mask all the negative values to keep only positive values (gt 0)
cdo -z zip2 setrtoc,-30,0,0 GFDL-ESM4_ssp126_tos_Omon_ALL_anom.nc GFDL-ESM4_ssp126_tos_Omon_ALL_anom_setrtoc.nc

# Compute the DHM; sum all positive values gt "0"
export CDO_TIMESTAT_DATE=last
cdo -z zip2 runsum,3 GFDL-ESM4_ssp126_tos_Omon_ALL_anom_setrtoc.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHM.nc

# Get the max DHM per year
export CDO_TIMESTAT_DATE=last
cdo -z zip yearmax GFDL-ESM4_ssp126_tos_Omon_ALL_DHM.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax.nc

# Mask as "1" the DHM values greater than 2 DHM's
cdo gtc,2 GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2.nc

# Compute the frequency of DHM gt 2 per 11 years; e.g. for 2025 count freq of 2020-2030
export CDO_TIMESTAT_DATE=middle 
cdo runsum,11 GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_frequency.nc

# Divide the frequency by 11 (the running 11 year period)
cdo expr,'var1=tos/11;' GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_frequency.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency.nc

# Mask as "1" the Frequency values greater than 0.2
cdo gec,0.2 GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_mask.nc

# Bring the mask grid to the data grid and set the mask value to 1
cdo -setvals,0,1 -remapycon,GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_mask.nc WCMC_reef_cells_1.nc reef_mask.nc

# multiply the data and the mask to cut out the region if interest
cdo mul GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_mask.nc reef_mask.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_reefs_mask.nc 

# # Mask as "1" the Frequency values greater than 0.2
# cdo gec,0.2 GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_reefs.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_reefs_mask.nc

# # Count the values per field (horizontally)
cdo fldsum GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_reefs_mask.nc GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_reefs_mask_fldsum.nc

done
done

# # save it as txt or cdv or xls 
ncdump GFDL-ESM4_ssp126_tos_Omon_ALL_DHMmax_gtc2_decadal_frequency_reefs_mask_fldsum.nc>DHM_bcorT_TABLE3.5.xls 
