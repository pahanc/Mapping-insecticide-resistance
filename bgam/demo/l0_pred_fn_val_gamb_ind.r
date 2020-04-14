pred_val_gamb<-function(tune_run,val_run,val_run2){

#TUNING
print(paste("tune_run",tune_run))
tune_run<-as.integer(tune_run)
print(paste("val_run",val_run))
val_run<-as.integer(val_run)
print(paste("val_run2",val_run2))
val_run2<-as.integer(val_run2)


#GAMB
library(mboost)
load("inputs_data_all_wa_fact5d.r")
data_all<-inputs$data_all_wa
covariate.names<-inputs$covariate.names.all.wa
source("load_gen.r")
load("stk_val_inds5.r")
load("non_spatial_val_sets6.r")
#Select indices for outer test set
stk_val_inds_i<-c(stk_val_inds[[val_run]][[1]],stk_val_inds[[val_run]][[2]],stk_val_inds[[val_run]][[3]],stk_val_inds[[val_run]][[4]])

#Empirical logit and IHS transform on labels
data_all[,"pcent_mortality"]<-emplogit2(data_all["no_dead"],data_all["no_tested"])
theta2<-optimise(IHS.loglik, lower=0.001, upper=50, x=data_all[,"pcent_mortality"],maximum=TRUE)
print(paste("theta2 maximum", theta2$maximum,sep=" "))
data_all[,"pcent_mortality"]<-IHS(data_all[,"pcent_mortality"],theta2$maximum)

#Specify hyperparameters
gambGrid <- expand.grid(mstop=50)
gambTuneGrid<-gambGrid[tune_run,]

gambPredJ<-list()

#Format for BGAM

covariate.namesa<-inputs$factor_cov_nms
cts_cov_inds<-which(!is.element(covariate.names,covariate.namesa))

	#bols model for factor covariates
covariate.namesa<-sapply(covariate.namesa,function(x) paste("bols(",x,",df=1)",sep=""))

	#bols & bbs model for continuous covariates with df=1 (see Hofner et al. 2014 "Model-based boosting in R")
covariate.namesb<-covariate.names[cts_cov_inds]
covariate.namesb<-sapply(covariate.namesb,function(x) paste("bbs(",x,",center=TRUE,df=1)+bols(",x,",intercept=FALSE)",sep=""))
covariate.namesb<-c("bols(int,intercept=FALSE)",covariate.namesb)

	#add an intercept
data_all$int<-rep(1,nrow(data_all))

covariate.names<-c(covariate.namesa,covariate.namesb)

model_lhs<-paste(covariate.names,collapse='+')

rmse<-NULL

#Select indices for the validation set excluding indices in the test set
test_inds_a<-val_ind[[val_run2]]
test_inds<-test_inds_a[which(!is.element(test_inds_a,stk_val_inds_i))]
testJ<-data_all[test_inds,c("pcent_mortality",inputs$covariate.names.all.wa,"int")]
train_inds<-c(1:nrow(data_all))[-test_inds]
trainJ<-data_all[-test_inds,c("pcent_mortality",inputs$covariate.names.all.wa,"int")]
test_inds_all<-test_inds

data_all_i<-rbind(trainJ,testJ)
data_all_i<-data_all_i[order(c(train_inds,test_inds)),]
data_all_i<-droplevels(data_all_i)
testJ<-data_all_i[test_inds,]
trainJ<-data_all_i[-test_inds,]

form<-as.formula(paste("pcent_mortality",model_lhs,sep="~"))

#Train the model
gambFitJ<-gamboost(form, data = trainJ, control=boost_control(mstop=gambTuneGrid,nu=0.4,risk="oobag"))

#Get out of sample predictions
gambPredJ<-predict(gambFitJ,newdata=testJ)

rmse<-sqrt(mean((gambPredJ-data_all[test_inds,"pcent_mortality"])^2))

output<-list()
output$rmse<-rmse
output$gambFitJ<-gambFitJ
output$gambPredJ<-gambPredJ
output$test_inds<-test_inds_all
output$data_all<-data_all
return(output)

}
