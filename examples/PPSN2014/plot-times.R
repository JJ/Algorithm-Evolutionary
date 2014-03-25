boxplot( trap.base.times$V1, trap.noisy.mem.w.times$V1, trap.noisy.times$V1,trap.noisy.mem.times$V1,ylab='Time (s)',log='y',xaxt='n',main='Time to solution',sub='4-Trap * 10')
axis(1, at=c(1,2,3,4),  las=0,labels=c('base','Wilcoxon','0-Memory','Memory'))
