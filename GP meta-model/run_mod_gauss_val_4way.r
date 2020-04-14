run_mod_gauss_val_4way<-function(function_nm,val_run){
	
	lapply(list.files(pattern="^load_gen\\.r$",recursive=FALSE),source)
        lapply(list.files(pattern="^indep_model_gen_gauss_4way_val\\.r$",recursive=FALSE),source)
	
	fun<-match.fun(function_nm,descend=FALSE)
	
	inputs_list<-fun(val_run)
	
	print(names(inputs_list))

	data1<-inputs_list$data1
	data2<-inputs_list$data2
	data3<-inputs_list$data3
	data4<-inputs_list$data4

	covariate.names1<-inputs_list$covariate.names1
	covariate.names2<-inputs_list$covariate.names2
	covariate.names3<-inputs_list$covariate.names3
	covariate.names4<-inputs_list$covariate.names4

	isel1<-inputs_list$isel1
    isel2<-inputs_list$isel2
    isel3<-inputs_list$isel3
    isel4<-inputs_list$isel4
    
    isel1a<-inputs_list$isel1a
    isel2a<-inputs_list$isel2a
    isel3a<-inputs_list$isel3a
    isel4a<-inputs_list$isel4a

	covs.fin1<-inputs_list$covs.fin1
    covs.fin2<-inputs_list$covs.fin2
    covs.fin3<-inputs_list$covs.fin3
    covs.fin4<-inputs_list$covs.fin4

	m1.cutoff<-inputs_list$m1.cutoff
	m1.min.angle<-inputs_list$m1.min.angle
	m1.max.edge<-inputs_list$m1.max.edge
	tmesh.yr.st<-inputs_list$tmesh.yr.st
	tmesh.yr.end<-inputs_list$tmesh.yr.end
	tmesh.yr.end2<-inputs_list$tmesh.yr.end2
	tmesh.yr.by<-inputs_list$tmesh.yr.by

	gauss_j.res<-indep_model_gen_gauss_4way_val(data1,data2,data3,data4,covariate.names1,covariate.names2,covariate.names3,covariate.names4,isel1,isel2,isel3,isel4,isel1a,isel2a,isel3a,isel4a,covs.fin1,covs.fin2,covs.fin3,covs.fin4,m1.cutoff,m1.min.angle,m1.max.edge,tmesh.yr.st,tmesh.yr.end,tmesh.yr.end2,tmesh.yr.by)

	return(gauss_j.res)

}

