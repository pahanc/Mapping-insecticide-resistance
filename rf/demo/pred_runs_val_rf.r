source("l0_pred_fn_val_rf.r")
args = commandArgs(trailingOnly=TRUE)
i<-1
print(paste("i",i))
j<-1
print(paste("j",j))
k<-args[1]
print(paste("k",k))
output<-pred_val_rf(i,j,k)
fname<-paste("rf_pred_val_run",k,".RData",sep="")
save(output,file=fname)
