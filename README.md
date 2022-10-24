# zeb-est
Analysis for zebra estimation ms

STEP 1 Combine locations

'/Data/ZebEncs_AccDB.cvs': this is the updated encounter file with 'corrected' animal identifications.

'/Data/zebLocsFromQGIS.cvs': contain animal locations calculated by eye from distance and direction in QGIS.

These are combined by encounter ID (EncID) to add animal locations to the updated Access DB.

Produces 'ZebEncsCombined.csv'


STEP 2 Set-up for NIMBLE (NOTE: switched to JAGS)

This script
1. loads 'ZebEncsCombined.csv', processes, organises zebra location data for analysis;
2. loads search path SHP files, calculates coordinates of thinned search path (i.e. locations of ends of path segments); chosen to reduce computational demands;
3. sets up data augmentation for estimating abundance;
4. rescales coordinates to produce spatial dimensions that are more manageable by NIMBLE (makes 'origin' of study area 0,0);
5. bundles data, constants, initial values and parameters-to-monitor into RData object 'ZebData.RData'.


STEP 3 Fit models

* prepared as a separate script to be uploaded, along with 'ZebData.RData', to the cluster for MCMC processing

1. loads RData object and separates data, constants, initial values, and parameters to separate objects;
(data and constants combined for JAGS processing)
2. specifies in BUGS language the model to be fit;
3. specifies MCMC settings (ni, nt, nc, nb)
4. fits model in NIMBLE; (now JAGS)
5. bundles everything into a function for parallel processing using 3 cores;
6. saves the chains as an RData output data file.


STEP 4 Post-processing

1. loads the saved chains;
2. runs summaries and plots.

* After getting everything running in NIMBLE, I struggled to get parallel processing working on the cluster; thus, I recoded everything for JAGS, which seems to run with no trouble