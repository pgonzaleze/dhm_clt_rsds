#!/bin/bash

# Trim data to match lenght of both databases; DHW and Clt
cdo seldate,1985-03-16,2100-12-16 GFDL-ESM4_ssp126_clt_Amon_Sen_anom.nc GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_trim.nc

# Change Clt form % to fraction [0-1]
cdo -divc,100 GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_trim.nc GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_adj.nc  

## Match the DHM and CF grids
cdo remapbil,GFDL-ESM4_ssp126_tos_Omon_ALL_DHM.nc GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_adj.nc GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_remap.nc

# Restric lmer to positive CFa values 
cdo setrtoc,0,0,0 GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_remap.nc GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_remap_setrtoc.nc

# Concatenate both ncfiles 
cdo merge GFDL-ESM4_ssp126_tos_Omon_ALL_DHM.nc GFDL-ESM4_ssp126_clt_Omon_Bcor_anom_remap_setrtoc.nc GFDL-ESM4_ssp126_DHM_clt.nc

# Bring the mask grid to the data grid and set the mask value to 1
cdo -setvals,0,1 -remapcon,GFDL-ESM4_ssp126_DHM_clt.nc WCMC_reef_cells_1.nc reef_mask.nc

# multiply the data and the mask to cut out the region if interest
cdo mul GFDL-ESM4_ssp126_DHM_clt.nc reef_mask.nc GFDL-ESM4_ssp126_DHM_clt_reefs.nc 

# mixed effect model projections
cdo expr,'severity_blx=(0.730+(0.7796*tos)+(-0.00310*clt)+(0.002662*(tos*clt)));' GFDL-ESM4_ssp126_DHM_clt_reefs.nc GFDL-ESM4_ssp126_DHM_clt_lmer.nc
#cdo expr,'severity_blx=(0.722+(0.7167*tos)+(0.3569*clt)+(-0.1425*(tos*clt)));' GFDL-ESM4_ssp126_DHM_clt.nc GFDL-ESM4_ssp126_DHM_clt_lmer.nc
#cdo expr,'severity_blx=(0.722+(0.7167*tos));' GFDL-ESM4_ssp126_DHM_clt.nc GFDL-ESM4_ssp126_DHM_clt_lmer.nc

### compute the decade frequency ### 
# Get the max DHM per year after the conditional
export CDO_TIMESTAT_DATE=last
cdo yearmax GFDL-ESM4_ssp126_DHM_clt_lmer.nc GFDL-ESM4_ssp126_DHMmax.nc

# Mask as "1" the severity values greater than 2.5 DHM´s
cdo gec,2.5 GFDL-ESM4_ssp126_DHMmax.nc GFDL-ESM4_ssp126_DHMmax_gtc2.nc

# Compute the frequency of DHM gt 2 per 11 years; e.g. for 2025 count freq of 2020-2030
export CDO_TIMESTAT_DATE=middle 
cdo runsum,11 GFDL-ESM4_ssp126_DHMmax_gtc2.nc GFDL-ESM4_ssp126_DHMmax_gtc2_frequency.nc

# Divide the frequency by 11 (the running 11 year period)
cdo expr,'freq=severity_blx/11;' GFDL-ESM4_ssp126_DHMmax_gtc2_frequency.nc GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency.nc

# Mask as "1" the Frequency values greater than 0.2
cdo gec,0.2 GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency.nc GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask.nc

# # Count the values per field (horizontally)
cdo fldsum GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask.nc GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask_fldsum.nc

# # save it as txt or cdv or xls 
ncdump GFDL-ESM4_ssp126_DHMmax_gtc2_decadal_frequency_reefs_mask_fldsum.nc>DHM_TABLE_2.5_amon.xls 