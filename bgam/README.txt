R Code for running the Boosted Generalized Additive Model (BGAM) analysis described in:

Hancock PA, Hendriks CJM, Tangena J-A, Gibson H, Hemingway J, Coleman M, Gething PW, Bhatt S, Moyes CL, “Mapping trends in insecticide resistance phenotypes in African malaria vectors”.

The BGAM model generates predictions on a test set containing results of standard insecticide susceptibility tests using a set of predictor variables.

System requirements: This code is written in R software, which runs on a wide variety of UNIX platforms, Windows and Mac OS. The R software is quick to install.

Software requirements: R, using the following packages:
mboost
LaplacesDemon
zoo

This code has been tested on R version 3.4.3 with the package mboost version 2.9-0, the package LaplacesDemon version 16.1.0 and the package zoo version 1.8-2.

Instructions for reproducing the 10-fold out-of-sample inner validation results for the BGAM model for a given outer validation set (from a set of 10 outer validation sets) are as follows:

For outer validation set 2 and inner validation set 3, run from the terminal command line:

Rscript pred_runs_val_gamb_ind.r 2 3 

This script requires the following the input following files:
1. "inputs_data_all_wa_fact5d.r": Data set with all the labels (bioassay proportional mortality) and features (predictor variables)
2. "load_gen.r" : source code for other R functions
3. "non_spatial_val_sets6.r": indices for the inner validation loop
4. "stk_val_inds5.r": indices for the outer validation loop
5. "pred_runs_val_gamb_ind.r": function for calling the boost script
6. "l0_pred_fn_val_gamb_ind.r": function for formatting the input data and training the boosted gam
