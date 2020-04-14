source("l0_pred_fn_val_gamb_ind.r")
args = commandArgs(trailingOnly=TRUE)
i<-1
j<-args[1]
print(paste("j",j))
k<-args[2]
print(paste("k",k))
output<-pred_val_gamb(i,j,k)
fname<-paste("gamb_pred_val_run",j,"_",k,".RData",sep="")
save(output,file=fname)
