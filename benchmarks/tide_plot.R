tide.opt <- read.csv( "tide_float_5.10.csv", sep=';' )
tide.opt.s <- tide.opt[order(tide.opt$Gen),]
tide.base <- read.csv( "tide_float_base.csv", sep=';' )
tide.base.s <- tide.base[order(tide.base$Gen),]
tide.opt.lm <- lm( tide.opt.s$Time ~ tide.opt.s$Gen )
tide.base.lm <- lm( tide.base.s$Time ~ tide.base.s$Gen )
plot( tide.base$Time ~ tide.base$Gen, pch=20, xlab='Generations', ylab='time (secs)', main='Interpreter match',sub='5.8 (black) vs. optimized 5.10 (red,dashed)' )
lines( sort(tide.base.s$Gen), fitted(tide.base.lm ), lwd=3)
points( tide.opt$Time ~ tide.opt$Gen,col='red', pch=23 )
lines( sort(tide.opt.s$Gen), fitted(tide.opt.lm), col='red', lwd=3, lty='dashed')
