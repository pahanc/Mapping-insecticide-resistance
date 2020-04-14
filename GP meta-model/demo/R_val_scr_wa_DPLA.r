source("inputs_list_wa_gauss_DPLA.r")
source("run_mod_gauss_val_4way.r")
args = commandArgs(trailingOnly=TRUE)
i<-args[1]
print(paste("i",i))
output<-run_mod_gauss_val_4way(inputs_list_wa_gauss_DPLA,i)
fname<-paste("gauss_res_val_wa_DPLA",i,".RData",sep="")
save(output,file=fname)

