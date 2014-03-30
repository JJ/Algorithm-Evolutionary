plot(res.afn.evals,type='o',ylab='Number', xlab='Noise sigma' ,xaxt='n', main='Number of evaluations', sub='4-Trap * 10',ylim=c(0,80000))
lines(res.afnm.evals, type='o',lty=2,col='red')
lines(res.afnmw.evals, type='o',lty=3,col='blue')
axis(1, at=c(1,2,3),  las=0, labels=c('1','2','4'))
