
inputs_list_wa_gauss_DPLA<-function(val_run){

inputs<-list()
val_run<-as.integer(val_run)
load("inputs_data_all_wa_l06.r")
inputs$data1<-make_inputs$data1[[val_run]]
inputs$data2<-make_inputs$data2[[val_run]]
inputs$data3<-make_inputs$data3[[val_run]]
inputs$data4<-make_inputs$data4[[val_run]]

inputs$covariate.names1<-make_inputs$covariate.names1
inputs$covariate.names2<-make_inputs$covariate.names2
inputs$covariate.names3<-make_inputs$covariate.names3
inputs$covariate.names4<-make_inputs$covariate.names4

inputs$isel1<-make_inputs$isel1[[val_run]]
inputs$isel2<-make_inputs$isel2[[val_run]]
inputs$isel3<-make_inputs$isel3[[val_run]]
inputs$isel4<-make_inputs$isel4[[val_run]]

inputs$isel1a<-make_inputs$isel1a[[val_run]]
inputs$isel2a<-make_inputs$isel2a[[val_run]]
inputs$isel3a<-make_inputs$isel3a[[val_run]]
inputs$isel4a<-make_inputs$isel4a[[val_run]]

inputs$covs.fin1<-make_inputs$covs.fin1[[val_run]]
inputs$covs.fin2<-make_inputs$covs.fin2[[val_run]]
inputs$covs.fin3<-make_inputs$covs.fin3[[val_run]]
inputs$covs.fin4<-make_inputs$covs.fin4[[val_run]]

inputs$m1.cutoff<-0.005
inputs$m1.min.angle<-c(25,25)
inputs$m1.max.edge<-c(0.05,1000)
inputs$tmesh.yr.st<-2005
inputs$tmesh.yr.end<-2017
inputs$tmesh.yr.end2<-2018
inputs$tmesh.yr.by<-2

return(inputs)

}


