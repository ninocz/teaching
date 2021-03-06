# Example growth accounting
# Based on: http://tinyurl.com/ycmp7sdk
# Data: http://www.rug.nl/ggdc/productivity/pwt/
# Load data
library(pwt9)
data("pwt9.0");pwt9.0
pwt<-pwt9.0[pwt9.0$year>=1960,] # Subset to years since 1960

# Create vectors
ccode<-unique((pwt$isocode))
N=length(ccode)
g=tfp=k=tfp.share=K.share=K<-c()

# Calculate 

for(i in 1:N){
  print(ccode[i])
  d<-pwt[pwt$isocode==ccode[i],] # Subset data to country
  
  # i) Calculate real output and capital per worker in national currency
  # ii)Take log and first difference to get percentage change
  dY=diff(log(d$rgdpna/d$emp))*100
  dK=diff(log(d$rkna/d$emp))*100
  
  # iii) Calculate Solow residual and change in TFP
  a=1-d[-1,]$labsh
  dtfp=dY-a*dK
  
  # iv) Calculate parameters per country
  g[i]=mean(dY,na.rm=TRUE)     # Growth rate
  tfp[i]=mean(dtfp,na.rm=TRUE) # TFP
  K[i]=mean(a*dK,na.rm=TRUE)   # Kapital
  tfp.share[i]=mean(dtfp,na.rm=TRUE)/mean(dY,na.rm=TRUE) # TFP share
  K.share[i]=mean(dK,na.rm=TRUE)/mean(dY,na.rm=TRUE)     # Capital share
}

# Plot: Capital and TFP versus growth rate
par(mar=c(5,5,2,2),bty='n',las=1,mfrow=c(1,2),cex.lab=2,cex.axis=2,cex.main=2)
plot(K,g,axes=FALSE,xlab='K',ylab='Growth',main='(a)')
axis(1,tick=FALSE)
axis(2,tick=FALSE)

plot(tfp,g,axes=FALSE,xlab='TFP',ylab='',main='(b)')
axis(1,tick=FALSE)

# Plot: Capital and TFP ratios
par(mfrow=c(1,1))
plot(K.share,tfp.share,xlim=c(-2.5,3),ylim=c(-1,2),cex=g,axes=FALSE,
     xlab='dK/dY',ylab='dA/dY')
axis(1,tick=FALSE);axis(2,tick=FALSE,line=-1)

## FIN
