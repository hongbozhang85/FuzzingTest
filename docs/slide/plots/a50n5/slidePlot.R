#### PARAMETERS ####
algtrials = 5
makeplots = TRUE
numworkers = 1000
numseeds = 700
campaignlength = 1000
trialblock = 100
lambdahigh = 1e-4
lambdalow = 1e-9
active = 15
exponentialdecay = 0.6
duration = campaignlength * trialblock
algtrials = 5
makeplots = TRUE

source("bayes.R")
source("naive.R")
source("epsilon_greedy.R")
source("optimal.R")
source("ftl.R")

ALGORITHMS = list(NAIVE, OPTIMAL, BAYES, EPSILON, FTL)
#ALGORITHMS = list(NAIVE, OPTIMAL)

grabData = function(ALG, tridx) {
    filename = paste(ALG$state$name, tridx, ".RData", sep="")
    # load the 'STORE' list of data
    load(file=filename)
    # we now should have a list of 'algtrials' of state data
    DATA = matrix(nrow=algtrials, ncol=duration)
    for (t in 1: algtrials) {
        Results = STORE[[t]]$Results
        DATA[t,] = cumsum(Results)
    }
    rm(STORE)
    return (DATA)
}

#### PLOTS ####
if (makeplots) {
    RESULTS <- list()
    SMOOTH <- list()
    m1 = 0
    algnames = c()
    for (ALG in ALGORITHMS) {
        algname = ALG$state$name
        # append the name for use in the legend
        algnames = c(algnames, algname)
        # pull out the data
        DATA = grabData(ALG, algtrials)
        RESULTS[[algname]] <- DATA
        SMOOTH[[algname]] <- colSums(DATA) / algtrials
        # find the greatest yield so we can format the yaxis nicely
        yield = max(DATA)
        if (yield > m1) {
            m1 = yield
        }
    }
    colours = c("black", "red", "blue", "darkgreen","purple")
    #colours = rainbow(length(ALGORITHMS))
    ylimit = ((m1 %/% 25) + 1) * 25

    ratio = 1.5

    ## ONE
    png("slide1.png",width=900,height=600)
    lads = c("0","20", "40", "60", "80", "100")
    ft = c(0,20000,40000,60000,80000,100000)
    plot(RESULTS[[1]][1,],
         type='l',
         col = "white",
         main = "Fuzzer Response: n -> 5",
         xaxt = "n",  # stops default x ticks labels
         xlab = "Iterations (10^6)",
         xlim = c(0,duration),
         ylab = "Crashes",
         ylim = c(0,ylimit),
         lwd = 2,
	 cex.axis=ratio,
	 cex.lab=ratio,
	 cey.axis = ratio,
	 cey.lab = ratio)
    axis(1, ft, lads, cex.axis = ratio)  # adds my custom x ticks labels
    # Now plot all the trial data
    for (idx in 1:length(algnames)) {
        alg = algnames[idx]
        colour = colours[idx]
        for (t in 1:algtrials) {
            points(RESULTS[[idx]][t,],
                type = 'l',
                col = colour,
                lwd = 1)
            points(SMOOTH[[alg]],
                type='l',
                col = colour,
                lwd=4)
        }
    }
    legend(x="bottomright", algnames, col=colours, text.col=colours, pch=NA, lwd=4, cex = 1.5)
    grid()
    # abline(h=seq(0,ylimit,20),v=seq(0,duration,500),col="grey",lty=3)
    dev.off()
}


