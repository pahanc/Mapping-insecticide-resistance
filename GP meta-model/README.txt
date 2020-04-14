R Code for running the Gaussian process stacked generalisation analysis described in:

Hancock PA, Hendriks CJM, Tangena J-A, Gibson H, Hemingway J, Coleman M, Gething PW, Bhatt S, Moyes CL, “Mapping trends in insecticide resistance phenotypes in African malaria vectors”.

The Gaussian process meta-model generates predictions on a test set containing results of standard insecticide susceptibility tests using a set of level-0 model predictions as predictor variables.

System requirements: This code is written in R software, which runs on a wide variety of UNIX platforms, Windows and Mac OS. The R software is quick to install.

Software requirements: R, using the following packages:
R-INLA
LaplacesDemon
zoo

This code has been tested on R version 3.4.3 with the package R-INLA version 17.06.2, the package LaplacesDemon version 16.1.0 and the package zoo version 1.8-2.

To run the spatiotemporal Gaussian Process meta-model on the out-of-sample predictions from the l0 models (XGB, RF and BGAM) for test set <i>, type from the terminal command line:

Rscript R_val_scr_wa_DPLA.r <i>

e.g Rscript R_val_scr_wa_DPLA.r 7

The "GP meta-model" directory contains the following files:

1. "inputs_data_all_wa_l06.r": Contains the out-of-sample predictions for each l0 model (XGB,RF and BGAM) for each data point in every outer validation fold.
2. "load_gen.r" : source code for other R functions
3. "indep_model_gen_gauss_4way_val.r": source code for implementing the spatiotemporal Gaussian process model.
4. "run_mod_gauss_val_4way.r": function for passing data to the spatiotemporal Gaussian process model.
5. "R_val_scr_wa_DPLA.r": source code for running the spatiotemporal Gaussian process model.
6. "inputs_list_wa_gauss_DPLA.r": collates inputs for the spatiotemporal Gaussian process metamodel and passes them to 5. 
