postscript('mmdp-gbx.eps',horizontal=FALSE,width=12, height=8,paper='special')
boxplot(resultados.mmdp.gbx$evaluations ~ resultados.mmdp.gbx$migration,main='2 nodes', sub='Length=64', ylab='Evaluations', cex.axis=0.8)
dev.off()

