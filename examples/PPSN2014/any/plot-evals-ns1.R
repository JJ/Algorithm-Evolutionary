boxplot(res.af.Trap.p1024.evals, res.afn.p1024.ns1.evals, res.afnm.Trap.p1024.ns1.evals, res.afnmw.p1024.ns1.evals,
        ylab='Number', xaxt='n', main='Number of evaluations, noise sigma = 1',sub='4-Trap * 10')
axis(1, at=c(1,2,3,4),  las=0, labels=c('base','0-Memory','ITA','WPO'))
