general.ea.128.500 <- read.csv('general_EA_128_500.csv', sep=';')
general.ea.128.500$Gen <- general.ea.128.500$Gen+1
general.ea.128.500.lm  <- lm(general.ea.128.500$Time ~general.ea.128.500$Gen )
general.ea.128.500.opt <- read.csv('general_EA_128_500_opt.csv', sep=';')
general.ea.128.500.opt$Gen <- general.ea.128.500.opt$Gen+1
general.ea.128.500.opt.lm  <- lm(general.ea.128.500.opt$Time ~general.ea.128.500.opt$Gen 
)
plot( general.ea.128.500$Time ~ general.ea.128.500$Gen, pch=20, xlab='Generations (*100)', ylab='time (secs)', main='General EA',sub='Interpreter match: 5.8 (black) vs. 5.10 (red)',ylim=c(0,23) )
lines( c(1:5), unique(fitted(general.ea.128.500.lm ))[0:5], lwd=3)
points( general.ea.128.500.opt$Time ~ general.ea.128.500.opt$Gen, pch=19, col='red' )
lines( c(1:5), unique(fitted(general.ea.128.500.opt.lm ))[0:5], col='red', lwd=3, lty='dashed')