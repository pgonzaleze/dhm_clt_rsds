#!/bin/bash

# Compute the Degree Heating Month index based on the Mixed effect model outputs 

# Trim data to match lenght of both databases; DHW and rsds
cdo -z zip seldate,1985-03-16,2100-12-16 GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom_trim.nc

## Match the DHM and rsds grids
cdo -z zip remapcon,GFDL-ESM4_ssp126_tos_Omon_ALL_DHM.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom_trim.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom_remap.nc

# Restric lmer to negative rsds values 
cdo -z zip setrtoc,0,0,0 GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom_remap.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom_remap_setrtoc.nc

# Concatenate both ncfiles 
cdo -z zip merge GFDL-ESM4_ssp126_tos_Omon_ALL_DHM.nc GFDL-ESM4_ssp126_rsds_Amon_Bcor_anom_remap_setrtoc.nc GFDL-ESM4_ssp126_DHM_rsds.nc

# mixed effect model projections
cdo expr,'severity_blx=(0.799+(0.7785*tos)+(0.002331*rsds));' GFDL-ESM4_ssp126_DHM_rsds.nc GFDL-ESM4_ssp126_DHM_rsds_lmer.nc

### compute the decade frequency ### 
# Get the max DHM per year after the conditional
cdo -z zip yearmax GFDL-ESM4_ssp126_DHM_rsds_lmer.nc GFDL-ESM4_ssp126_DHMmax.nc

# Mask as "1" the severity values greater than 2 DHM´s
cdo gec,2 GFDL-ESM4_ssp126_DHMmax.nc GFDL-ESM4_ssp126_DHMmax_gtc2.nc

# Compute the frequency of DHM gt 2 per 11 years; e.g. for 2025 count freq of 2020-2030
export CDO_TIMESTAT_DATE=middle 
cdo runsum,11 GFDL-ESM4_ssp126_DHMmax_gtc2.nc GFDL-ESM4_ssp126_DHMmax_gtc2_frequency.nc

# Divide the frequency by 11 (the running 11 year period)
cdo expr,'freq=severity_blx/11;' GFDL-ESM4_ssp126_DHMmax_gtc2_frequency.nc GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency.nc

# Bring the mask grid to the data grid and set the mask value to 1
cdo -setvals,0,1 -remapycon,GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency.nc WCMC_reef_cells_1.nc reef_mask.nc

# multiply the data and the mask to cut out the region if interest
cdo mul GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency.nc reef_mask.nc GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs.nc 

# Mask as "1" the Frequency values greater than 0.2
cdo gec,0.2 GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs.nc GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask.nc

# # Count the values per field (horizontally)
cdo fldsum GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask.nc GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask_fldsum.nc

# # save it as txt or cdv or xls 
ncdump GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask_fldsum.nc>DHM_RSDS_TABLE.xls 