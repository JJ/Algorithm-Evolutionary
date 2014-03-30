boxplot(res.afn.p1024.ns4.evals, res.afnm.p1024.ns4.evals, res.afnmw.p1024.ns4.evals,
        ylab='Number', xaxt='n', main='Number of evaluations, noise sigma = 4',sub='4-Trap * 10')
axis(1, at=c(1,2,3),  las=0, labels=c('Memory','ETA','WPO'))
