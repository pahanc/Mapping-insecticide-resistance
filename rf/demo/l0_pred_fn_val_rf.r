pred_val_rf<-function(tune_run,tune_run2,val_run){

print(paste("tune_run",tune_run))
print(paste("tune_run2",tune_run2))
tune_run<-as.integer(tune_run)
tune_run2<-as.integer(tune_run2)
print(paste("val_run",val_run))
val_run<-as.integer(val_run)

#RF
library(caret)
library(data.table)
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

model_lhs<-paste(c(inputs$covariate.names.all.wa),collapse='+')

#Specify hyperparameters
rfGrid <- expand.grid(mtry=150)
rfPredJ<-list()
rfTuneGrid<-data.frame(rfGrid[tune_run,])
colnames(rfTuneGrid)<-"mtry"
params<-expand.grid(nfold=8,col_sample_rate_per_tree=0.8,nodesize=20)
paramsTuneGrid<-params[tune_run2,]

l0_predictions<-list()

#Select indices for the validation set excluding indices in the test set
test_inds_a<-val_ind[[1]]
test_inds<-test_inds_a[which(!is.element(test_inds_a,stk_val_inds_i))]

testJ<-data_all[test_inds,]

train_inds<-which(!is.element(1:nrow(data_all),c(val_ind[[1]],stk_val_inds_i)))
trainJ<-data_all[train_inds,]

test_inds_all<-test_inds

#Format for RF
form<-as.formula(paste("pcent_mortality",model_lhs,sep="~"))

#Train the model
rfFitJ<-train(form, data = trainJ, method = "rf",verbose = TRUE,tuneGrid=rfTuneGrid,ntree=5,replace=TRUE,metric="RMSE",col_sample_rate_per_tree=paramsTuneGrid$col_sample_rate_per_tree,nodesize=paramsTuneGrid$nodesize)

#Get out of sample predictions
rfPredJ[[1]]<-predict(rfFitJ,newdata=testJ)

#Go through the other outer validation sets
for (i in 2:length(stk_val_inds)){
test_inds_a<-val_ind[[i]]
test_inds<-test_inds_a[which(!is.element(test_inds_a,stk_val_inds_i))]
testJ<-data_all[test_inds,]
train_inds<-which(!is.element(1:nrow(data_all),c(val_ind[[i]],stk_val_inds_i)))
trainJ<-data_all[train_inds,]

test_inds_all<-c(test_inds_all,test_inds)

rfFitJ<-train(form, data = trainJ, method = "rf", verbose = TRUE,tuneGrid=rfTuneGrid,ntree=5,replace=TRUE,metric="RMSE",col_sample_rate_per_tree=paramsTuneGrid$col_sample_rate_per_tree,nodesize=paramsTuneGrid$nodesize)

rfPredJ[[i]]<-predict(rfFitJ,newdata=testJ)

print(paste("l0_run ",i))

output<-list()
output$l0_run<-i
output$rfFitJ<-rfFitJ
output$rfPredJ<-rfPredJ
output$test_inds_all<-test_inds_all	

}

rfPredAll<-unlist(rfPredJ)
l0_predictions[[1]]<-rfPredAll
l0_predictions[[2]]<-test_inds_all

output<-list()
output$l0_predictions<-l0_predictions
output$data_all<-data_all
return(output)

}#end function
