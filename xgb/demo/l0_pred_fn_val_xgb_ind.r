pred_val_xgb<-function(tune_run,tune_run2,val_run,val_run2){

print(paste("tune_run",tune_run))
print(paste("tune_run2",tune_run2))
print(paste("val_run",val_run))
print(paste("val_run2",val_run2))
tune_run<-as.integer(tune_run)
tune_run2<-as.integer(tune_run2)
val_run<-as.integer(val_run)
val_run2<-as.integer(val_run2)

#XGB
library(data.table)
library(xgboost)
source("load_gen.r")
load("inputs_data_all_wa_tree5d.r")
data_all<-inputs$data_all_wa
load("stk_val_inds5.r")
load("non_spatial_val_sets6.r")

covariate.names<-inputs$covariate.names.all.wa
#Select indices for outer test set
stk_val_inds_i<-c(stk_val_inds[[val_run]][[1]],stk_val_inds[[val_run]][[2]],stk_val_inds[[val_run]][[3]],stk_val_inds[[val_run]][[4]])

#Empirical logit and IHS transform on labels
data_all[,"pcent_mortality"]<-emplogit2(data_all["no_dead"],data_all["no_tested"])
theta2<-optimise(IHS.loglik, lower=0.001, upper=50, x=data_all[,"pcent_mortality"],maximum=TRUE)
print(paste("theta2 maximum", theta2$maximum,sep=" "))
data_all[,"pcent_mortality"]<-IHS(data_all[,"pcent_mortality"],theta2$maximum)

#Specify hyperparameters
xgbTuneGrid<-expand.grid(booster="dart",max_depth = 8,eta = 0.001,gamma =0.5,min_child_weight=7,colsample_bytree=0.7,subsample=0.7,lambda=1)
params<-expand.grid(rate_drop=c(0.001,0.002)) 
rate_drop<-params[tune_run2,] 
                     

xgbPredJ<-list()

#Select indices for the validation set excluding indices in the test set
test_inds_a<-val_ind[[val_run2]]
test_inds<-test_inds_a[which(!is.element(test_inds_a,stk_val_inds_i))]

testJ<-data_all[test_inds,]

train_inds<-which(!is.element(1:nrow(data_all),c(val_ind[[val_run2]],stk_val_inds_i)))
trainJ<-data_all[train_inds,]

test_inds_all<-test_inds

#Format for XGB
testJ<-data.matrix(testJ)
trainJ<-data.matrix(trainJ)
response<-trainJ[,"pcent_mortality"]
covariates<-as.matrix(trainJ[,inputs$covariate.names.all.wa])
colnames(covariates)<-inputs$covariate.names.all.wa
trainJ<-xgb.DMatrix(data=covariates,label=response)

#Train the model
xgbFitJ<-xgb.train(params=xgbTuneGrid,nthread=1,data = trainJ,nrounds=50, rate_drop=rate_drop,verbose = TRUE)

#Get out of sample predictions
response_p<-testJ[,"pcent_mortality"]
covariates_p<-as.matrix(testJ[,inputs$covariate.names.all.wa])
testJ<-xgb.DMatrix(data=covariates_p,label=response_p)
xgbPredJ<-predict(xgbFitJ,testJ,ntree_limit=50)

print(paste("l0_run ",val_run2))

output<-list()
output$l0_run<-val_run
output$xgbFitJ<-xgbFitJ
output$xgbPredJ<-xgbPredJ
output$test_inds_all<-test_inds_all
output$data_all<-data_all

return(output)

}#end function
