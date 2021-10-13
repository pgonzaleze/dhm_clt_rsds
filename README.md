# dhm_clt_rsds
Repository with data regarding the paper "Cloudiness delays projected impact of climate change on coral reefs"
+ The coral bleaching database is available at https://www.simondonner.com/bleachingdatabase
+ The NOAA Coral Reef Watch CoralTemp Version 3.1 Daily Global 5 km is publicly available at https://coralreefwatch.noaa.gov/product/5km/index.php 
+ The Downward short-wave radiation at the surface (RSDS) and total cloud area (CLT) data from the Geophysical Fluid Dynamics Laboratory’s ESM4 model (GFDL-ESM4) are publicly available at https://esgf-node.llnl.gov 

The NetCDF files are edited using CDO; read the "README_CDO_code" 

Each python notebook is used to extract each metric or variable per bleaching report and to perform the Random Forest classificaton model.

R script is used to perform mixed-effects models
