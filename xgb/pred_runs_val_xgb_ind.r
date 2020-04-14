source("l0_pred_fn_val_xgb_ind.r")
args = commandArgs(trailingOnly=TRUE)
i<-1
print(paste("i",i))
j<-2
print(paste("j",j))
k<-args[1]
print(paste("k",k))
m<-args[2]
print(paste("m",m))
output<-pred_val_xgb(i,j,k,m)
fname<-paste("xgb_pred_val_run",k,"_",m,".r",sep="")
save(output,file=fname)
