#library(INLA)
#library(LaplacesDemon)
#library(zoo)
#ll.to.xyz<-function(ll){
#	if(is.null(colnames(ll))){
#		colnames(ll)<-c('longitude','latitude')
#	}
#	if(colnames(ll)[1]=='x' & colnames(ll)[2]=='y'){
#		colnames(ll)<-c('longitude','latitude')
#	}
#	if(colnames(ll)[1]=='lon' & colnames(ll)[2]=='lat'){
#		colnames(ll)<-c('longitude','latitude')
#	}
#	ll[,'longitude']<-ll[,'longitude']*(pi/180)
#	ll[,'latitude']<-ll[,'latitude']*(pi/180)
#	x = cos(ll[,'latitude']) * cos(ll[,'longitude'])
#	y = cos(ll[,'latitude']) * sin(ll[,'longitude'])
#	z = sin(ll[,'latitude'])
#	return(cbind(x,y,z))
#}
#temporalInfo<- function(f){
#	library(zoo)
#	start_dates<-as.yearmon(paste(f[, "year_start"], "-", f[, "month_start"],sep=""))
#	end_dates<-as.yearmon(paste(f[, "year_end"], "-", f[, "month_end"],sep=""))
#	mid_dates<-(start_dates+end_dates)/2
#	return(as.numeric(mid_dates))
#}
emplogit<-function(Y,N) {top=Y*N+0.5;bottom=N*(1-Y)+0.5;return(log(top/bottom))} # empirical logit number
emplogit2<-function(Y,N) {top=Y+0.5;bottom=N-Y+0.5;return(log(top/bottom))} # empirical logit two numbers
emplogit3<-function(Y,N) {top=Y+1.5;bottom=N-Y+1.5;return(log(top/bottom))}
emplogit4<-function(p) {top=p+0.015;bottom=1-p+0.015;return(log(top/bottom))}

IHS <- function(x, theta){# Inverse IHS transformation
(1/theta)*asinh(theta * x)
}

Inv.IHS <- function(x, theta){# IHS transformation
(1/theta)*sinh(theta * x)
}

IHS.loglik <- function(theta,x){
n <- length(x)
xt <- IHS(x, theta)
log.lik <- -n*log(sum((xt - mean(xt))^2))- sum(log(1+theta^2*x^2))
return(log.lik)
}
