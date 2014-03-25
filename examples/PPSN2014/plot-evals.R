boxplot( trap.base.evals$V1, trap.noisy.mem.w.evals$V1, trap.noisy.evals$V1,trap.noisy.mem.evals$V1,ylab='Number',log='y',xaxt='n',main='Number of evaluations',sub='4-Trap * 10')
axis(1, at=c(1,2,3,4),  las=0,labels=c('base','Wilcoxon','0-Memory','Memory'))
