indep_model_gen_gauss_4way_val<-function(data1,data2,data3,data4,covariate.names1,covariate.names2,covariate.names3,covariate.names4,isel1,isel2,isel3,isel4,isel1a,isel2a,isel3a,isel4a,covs.fin1,covs.fin2,covs.fin3,covs.fin4,m1.cutoff,m1.min.angle,m1.max.edge,tmesh.yr.st,tmesh.yr.end,tmesh.yr.end2,tmesh.yr.by){

#Perform empirical logit and IHS transformations of the response variable
data1[,"pcent_mortality"]<-emplogit2(data1[,"no_dead"],data1[,"no_tested"])
data1[,"pcent_mortality"]<-IHS(data1[,"pcent_mortality"],theta<-0.00108101531377662)

data2[,"pcent_mortality"]<-emplogit2(data2[,"no_dead"],data2[,"no_tested"])
data2[,"pcent_mortality"]<-IHS(data2[,"pcent_mortality"],theta<-0.00108101531377662)

data3[,"pcent_mortality"]<-emplogit2(data3[,"no_dead"],data3[,"no_tested"])
data3[,"pcent_mortality"]<-IHS(data3[,"pcent_mortality"],theta<-0.00108101531377662)

data4[,"pcent_mortality"]<-emplogit2(data4[,"no_dead"],data4[,"no_tested"])
data4[,"pcent_mortality"]<-IHS(data4[,"pcent_mortality"],theta<-0.00108101531377662)

#Get the covariate values (l0 out-of-sample predictions)
if (length(covariate.names1)>1) {
	data1.cov<-data1[,covariate.names1]
	data2.cov<-data2[,covariate.names2]
	data3.cov<-data3[,covariate.names3]
	data4.cov<-data4[,covariate.names4]
	} else {
	data1.cov<-list(data1[,covariate.names1])
	data2.cov<-list(data2[,covariate.names2])
	data3.cov<-list(data3[,covariate.names3])
	data4.cov<-list(data4[,covariate.names4])
	names(data1.cov)<-covariate.names1
	names(data2.cov)<-covariate.names2
	names(data3.cov)<-covariate.names3
	names(data4.cov)<-covariate.names4
	}

long_lat1<-cbind(data1[,"longitude"],data1[,"latitude"])
long_lat2<-cbind(data2[,"longitude"],data2[,"latitude"])
long_lat3<-cbind(data3[,"longitude"],data3[,"latitude"])
long_lat4<-cbind(data4[,"longitude"],data4[,"latitude"])

long_lat_all<-rbind(long_lat1,long_lat2,long_lat3,long_lat4)
#Convert latitudes and longitudes to spherical coordinate system
xyz_all<-ll.to.xyz(long_lat_all)
coords_est_all<-as.data.frame(xyz_all)

#Remove duplicates
un<-paste(coords_est_all$x,coords_est_all$y,coords_est_all$z,sep=':')
dup<-!duplicated(un)
mesh = inla.mesh.2d(loc=cbind(coords_est_all[dup,'x'],coords_est_all[dup,'y'],coords_est_all[dup,'z']),
	cutoff=m1.cutoff,
	min.angle=m1.min.angle,
	max.edge=m1.max.edge)

xyz1<-ll.to.xyz(cbind(long_lat1[,1],long_lat1[,2]))
coords_est1<-as.data.frame(xyz1)
xyz2<-ll.to.xyz(cbind(long_lat2[,1],long_lat2[,2]))
coords_est2<-as.data.frame(xyz2)
xyz3<-ll.to.xyz(cbind(long_lat3[,1],long_lat3[,2]))
coords_est3<-as.data.frame(xyz3)
xyz4<-ll.to.xyz(cbind(long_lat4[,1],long_lat4[,2]))
coords_est4<-as.data.frame(xyz4)

#Format temporal data
temp_inf1<-data.frame(year_start=as.numeric(as.character(data1[,"start_year"])),month_start=as.numeric(as.character(data1[,"start_month"])),year_end=as.numeric(as.character(data1[,"end_year"])),month_end=as.numeric(as.character(data1[,"end_month"])))

ind<-which(is.na(temp_inf1$month_start))
temp_inf1$month_start[ind]=1
ind<-which(is.na(temp_inf1$month_end))
temp_inf1$month_end[ind]=12
ind<-which(is.na(temp_inf1$year_end))
temp_inf1$year_end[ind]=temp_inf1$year_start[ind]

year1<-temporalInfo(temp_inf1)

temp_inf2<-data.frame(year_start=as.numeric(as.character(data2[,"start_year"])),month_start=as.numeric(as.character(data2[,"start_month"])),year_end=as.numeric(as.character(data2[,"end_year"])),month_end=as.numeric(as.character(data2[,"end_month"])))

ind<-which(is.na(temp_inf2$month_start))
temp_inf2$month_start[ind]=1
ind<-which(is.na(temp_inf2$month_end))
temp_inf2$month_end[ind]=1
ind<-which(is.na(temp_inf2$year_end))
temp_inf2$year_end[ind]=temp_inf2$year_start[ind]

year2<-temporalInfo(temp_inf2)

temp_inf3<-data.frame(year_start=as.numeric(as.character(data3[,"start_year"])),month_start=as.numeric(as.character(data3[,"start_month"])),year_end=as.numeric(as.character(data3[,"end_year"])),month_end=as.numeric(as.character(data3[,"end_month"])))


ind<-which(is.na(temp_inf3$month_start))
temp_inf3$month_start[ind]=1
ind<-which(is.na(temp_inf3$month_end))
temp_inf3$month_end[ind]=1
ind<-which(is.na(temp_inf3$year_end))
temp_inf3$year_end[ind]=temp_inf3$year_start[ind]

year3<-temporalInfo(temp_inf3)

temp_inf4<-data.frame(year_start=as.numeric(as.character(data4[,"start_year"])),month_start=as.numeric(as.character(data4[,"start_month"])),year_end=as.numeric(as.character(data4[,"end_year"])),month_end=as.numeric(as.character(data4[,"end_month"])))

ind<-which(is.na(temp_inf4$month_start))
temp_inf4$month_start[ind]=1
ind<-which(is.na(temp_inf4$month_end))
temp_inf4$month_end[ind]=12
ind<-which(is.na(temp_inf4$year_end))
temp_inf4$year_end[ind]=temp_inf4$year_start[ind]

year4<-temporalInfo(temp_inf4)

#Make the mesh of time knots
mesh1d=inla.mesh.1d(seq(tmesh.yr.st,tmesh.yr.end,by=tmesh.yr.by),interval=c(tmesh.yr.st,tmesh.yr.end2),degree=2, boundary='free')

#Make the spatial SPDE mesh
IRT_spde<-inla.spde2.pcmatern(mesh=mesh,alpha=2,prior.range=c(0.0003,0.01),prior.sigma=c(5,0.01))

#First insecticide
IRT_dat1 <- data.frame(y=as.vector(data1[,7]), w=rep(1,length(data1[,7])), year<-year1, xcoo=coords_est1[,1],
                     ycoo=coords_est1[,2],zcoo=coords_est1[,3],cov<-data1.cov)
                       
IRT_dat1_c<-IRT_dat1[-isel1a,]

IRT_dat1_v <- data.frame(y=rep(NA,nrow(IRT_dat1)), w=rep(1,length(data1[,7])), year<-year1, xcoo=coords_est1[,1],
                     ycoo=coords_est1[,2],zcoo=coords_est1[,3], cov<-covs.fin1)[isel1a,]
                     
IRT_iset1 <- inla.spde.make.index('one.field', n.spde=mesh$n, n.group=mesh1d$m)

IRT_A1_c <- inla.spde.make.A(mesh,loc=cbind(IRT_dat1_c$xcoo, IRT_dat1_c$ycoo,IRT_dat1_c$zcoo),group=IRT_dat1_c$year,group.mesh=mesh1d)

IRT_A1_v <- inla.spde.make.A(mesh,loc=cbind(IRT_dat1_v$xcoo, IRT_dat1_v$ycoo,IRT_dat1_v$zcoo),group=IRT_dat1_v$year,group.mesh=mesh1d)

IRT_stk1_c <- inla.stack(tag='one.data', data=list(y=cbind(IRT_dat1_c$y,NA,NA,NA)), A=list(IRT_A1_c,1),effects=list(IRT_iset1, list(b0.1=IRT_dat1_c$w,IRT_dat1_c[,covariate.names1])))

IRT_stk1_v <- inla.stack(tag='one.val', data=list(y=cbind(IRT_dat1_v$y,NA,NA,NA)), A=list(IRT_A1_v,1),effects=list(IRT_iset1, list(b0.1=IRT_dat1_v$w,IRT_dat1_v[,covariate.names1])))	
 
#Second insecticide

IRT_dat2 <- data.frame(y=as.vector(data2[,7]), w=rep(1,length(data2[,7])), year<-year2, xcoo=coords_est2[,1],
                     ycoo=coords_est2[,2],zcoo=coords_est2[,3],cov<-data2.cov)
                       
IRT_dat2_c<-IRT_dat2[-isel2a,]

IRT_dat2_v <- data.frame(y=rep(NA,nrow(IRT_dat2)), w=rep(1,length(data2[,7])), year<-year2, xcoo=coords_est2[,1],
                     ycoo=coords_est2[,2],zcoo=coords_est2[,3], cov<-covs.fin2)[isel2a,]

IRT_iset2 <- inla.spde.make.index('two.field', n.spde=mesh$n, n.group=mesh1d$m)

IRT_A2_c <- inla.spde.make.A(mesh,loc=cbind(IRT_dat2_c$xcoo, IRT_dat2_c$ycoo,IRT_dat2_c$zcoo),group=IRT_dat2_c$year,group.mesh=mesh1d)

IRT_A2_v <- inla.spde.make.A(mesh,loc=cbind(IRT_dat2_v$xcoo, IRT_dat2_v$ycoo,IRT_dat2_v$zcoo),group=IRT_dat2_v$year,group.mesh=mesh1d)

IRT_stk2_c <- inla.stack(tag='two.data', data=list(y=cbind(NA,IRT_dat2_c$y,NA,NA)), A=list(IRT_A2_c,1),effects=list(IRT_iset2, list(b0.2=IRT_dat2_c$w,IRT_dat2_c[,covariate.names2])))

IRT_stk2_v <- inla.stack(tag='two.val', data=list(y=cbind(NA,IRT_dat2_v$y,NA,NA)), A=list(IRT_A2_v,1),effects=list(IRT_iset2, list(b0.2=IRT_dat2_v$w,IRT_dat2_v[,covariate.names2])))	


#Third insecticide

IRT_dat3 <- data.frame(y=as.vector(data3[,7]), w=rep(1,length(data3[,7])), year<-year3, xcoo=coords_est3[,1],
                     ycoo=coords_est3[,2],zcoo=coords_est3[,3],cov<-data3.cov)
                       
IRT_dat3_c<-IRT_dat3[-isel3a,]

IRT_dat3_v <- data.frame(y=rep(NA,nrow(IRT_dat3)), w=rep(1,length(data3[,7])), year<-year3, xcoo=coords_est3[,1],
                     ycoo=coords_est3[,2],zcoo=coords_est3[,3], cov<-covs.fin3)[isel3a,]

IRT_iset3 <- inla.spde.make.index('three.field', n.spde=mesh$n, n.group=mesh1d$m)

IRT_A3_c <- inla.spde.make.A(mesh,loc=cbind(IRT_dat3_c$xcoo, IRT_dat3_c$ycoo,IRT_dat3_c$zcoo),group=IRT_dat3_c$year,group.mesh=mesh1d)

IRT_A3_v <- inla.spde.make.A(mesh,loc=cbind(IRT_dat3_v$xcoo, IRT_dat3_v$ycoo,IRT_dat3_v$zcoo),group=IRT_dat3_v$year,group.mesh=mesh1d)

IRT_stk3_c <- inla.stack(tag='three.data', data=list(y=cbind(NA,NA,IRT_dat3_c$y,NA)), A=list(IRT_A3_c,1),effects=list(IRT_iset3, list(b0.3=IRT_dat3_c$w,IRT_dat3_c[,covariate.names3])))

IRT_stk3_v <- inla.stack(tag='three.val', data=list(y=cbind(NA,NA,IRT_dat3_v$y,NA)), A=list(IRT_A3_v,1),effects=list(IRT_iset3, list(b0.3=IRT_dat3_v$w,IRT_dat3_v[,covariate.names3])))	

#Fourth insecticide

IRT_dat4 <- data.frame(y=as.vector(data4[,7]), w=rep(1,length(data4[,7])), year<-year4, xcoo=coords_est4[,1],
                     ycoo=coords_est4[,2],zcoo=coords_est4[,3],cov<-data4.cov)
                       
IRT_dat4_c<-IRT_dat4[-isel4a,]

IRT_dat4_v <- data.frame(y=rep(NA,nrow(IRT_dat4)), w=rep(1,length(data4[,7])), year<-year4, xcoo=coords_est4[,1],
                     ycoo=coords_est4[,2],zcoo=coords_est4[,3], cov<-covs.fin4)[isel4a,]

IRT_iset4 <- inla.spde.make.index('four.field', n.spde=mesh$n, n.group=mesh1d$m)

IRT_A4_c <- inla.spde.make.A(mesh,loc=cbind(IRT_dat4_c$xcoo, IRT_dat4_c$ycoo,IRT_dat4_c$zcoo),group=IRT_dat4_c$year,group.mesh=mesh1d)

IRT_A4_v <- inla.spde.make.A(mesh,loc=cbind(IRT_dat4_v$xcoo, IRT_dat4_v$ycoo,IRT_dat4_v$zcoo),group=IRT_dat4_v$year,group.mesh=mesh1d)

IRT_stk4_c <- inla.stack(tag='four.data', data=list(y=cbind(NA,NA,NA,IRT_dat4_c$y)), A=list(IRT_A4_c,1),effects=list(IRT_iset4, list(b0.4=IRT_dat4_c$w,IRT_dat4_c[,covariate.names4])))

IRT_stk4_v <- inla.stack(tag='four.val', data=list(y=cbind(NA,NA,NA,IRT_dat4_v$y)), A=list(IRT_A4_v,1),effects=list(IRT_iset4, list(b0.4=IRT_dat4_v$w,IRT_dat4_v[,covariate.names4])))	

#Make the INLA stack
j.stk <- inla.stack(IRT_stk1_c,IRT_stk1_v,IRT_stk2_c,IRT_stk2_v,IRT_stk3_c,IRT_stk3_v,IRT_stk4_c,IRT_stk4_v)

#Specify priors on the measurement noise and the temporal autocorrelation
eprec<- list(hyper=list(theta=list(prior='pc.prec', param=c(5, 0.01))))
pcrho<-list(theta=list(prior='pccor0', param=c(0.5, 0.5))) 

#Constrain the fixed effect coefficients to be within the range of (0,1)
covariate.names1<-sapply(covariate.names1,function(x) paste("f(",x,",model='clinear',range=c(0,1),initial=0.2)",sep=""))

gauss_jform <- as.formula(paste(paste("y ~ -1 + b0.1 + b0.2 + b0.3 + b0.4 + f(one.field, model=IRT_spde, group=one.field.group,control.group=list(model='ar1',hyper=pcrho)) + f(two.field,model=IRT_spde, group=two.field.group,control.group=list(model='ar1',hyper=pcrho))+ f(three.field,model=IRT_spde, group=three.field.group,control.group=list(model='ar1',hyper=pcrho)) + f(four.field,model=IRT_spde, group=four.field.group,control.group=list(model='ar1',hyper=pcrho))+",paste(c(covariate.names1),collapse='+'),sep="")))

#Run the INLA model
gauss_j.res <- inla(gauss_jform, family=c('Gaussian','Gaussian','Gaussian','Gaussian'), data=inla.stack.data(j.stk),control.family=list(eprec,eprec,eprec,eprec), control.predictor=list(compute=TRUE,A=inla.stack.A(j.stk)),control.compute=list(config=TRUE,cpo=TRUE,dic=TRUE,waic=TRUE),control.inla=list(int.strategy='eb'))

output<-list()
output$gauss_j.res<-gauss_j.res
output$mesh<-mesh
output$mesh1d<-mesh1d
output$isel1<-isel1
output$isel2<-isel2
output$isel3<-isel3
output$isel4<-isel4
output$isel1a<-isel1a
output$isel2a<-isel2a
output$isel3a<-isel3a
output$isel4a<-isel4a

return(output)

}

