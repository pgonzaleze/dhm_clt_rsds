#!/bin/bash
# Perform a sesitivity analysis of CLT anomalies 
for file in GFDL-ESM4_ssp126_clt_Amon.nc
do
echo i$
for file in "ls GFDL-ESM4_ssp126_clt_Amon.nc"
do

# First, subset the years 1985-2100 to compute the final anomaly
cdo -z zip -selyear,1985/2100 GFDL-ESM4_ssp126_clt_Amon.nc GFDL-ESM4_ssp126_clt_Amon_1985-2100.nc

# match grids 
cdo -z zip remapcon,CERES_EBAF-TOA_Ed4.1_climatology.nc GFDL-ESM4_ssp126_clt_Amon_1985-2100.nc GFDL-ESM4_ssp126_clt_Amon_1985-2100_rm.nc

# Compute the anomaly (data-climatology)
cdo sub -selmonth,1/12 GFDL-ESM4_ssp126_clt_Amon_1985-2100_rm.nc CERES_EBAF-TOA_Ed4.1_climatology.nc GFDL-ESM4_ssp126_clt_Amon_Sen_anom.nc 

# Compute correlation between anomalies calculations
cdo timcor GFDL-ESM4_ssp126_clt_Amon_Sen_anom.nc GFDL-ESM4_ssp126_clt_Omon_Bcor_anom.nc GFDL-ESM4_ssp126_clt_anom_correlation.nc

# extract values for reef cells
# multiply the data and the WCMC reef cells mask to cut out the region if interest
cdo mul GFDL-ESM4_ssp126_clt_anom_correlation.nc  WCMC_reef_cells_1.nc GFDL-ESM4_ssp126_clt_anom_correlation_reefs.nc

done
done