library(parallel)

#### PARAMETERS ####
numworkers = 1000
numseeds = 700
campaignlength = 1000
trialblock = 100
lambdahigh = 1e-4
lambdalow = 1e-9
active = 15
exponentialdecay = 0.6
duration = campaignlength * trialblock
algtrials = 10 
makeplots = TRUE

printProgress = function(state, trial, rep) {
    # print updates
    crashes = sum(state$Results[1:trial])
    util = length(unique(state$WorkerAssignment))
    name = state$name
    cat("Name: ", name, " -- Algorithm Trial: ", rep, " Iteration: ", trial, " Crashes: ", crashes, " Diversity: ", util, "\n")
}

source("bayes.R")
source("naive.R")
source("epsilon_greedy.R")
source("optimal.R")
source("ftl.R")
source("vary_greedy.R")

numCores = 6 #detectCores() - 1

cluster = makeCluster(numCores,type="FORK")

## Best to run each algorithm on a seperate ccpu core using serpate R sessions...
ALGORITHMS = list(BAYES, EPSILON, NAIVE, OPTIMAL, FTL,VarEPSILON)

simulate = function(ALG) {
#for (ALG in ALGORITHMS) {
#for (ALG in ALGORI) {
    STORE = list()
    for (rep in 1:algtrials) {
        ALG$state <- ALG$init()
        #### SIMULATION  ###
        for (trialsession in 1:duration) {
            if (trialsession %% 100 == 1) {
                printProgress(ALG$state, trialsession, rep)
            }
            ### PULL bandit arms ###
            ALG$state <- ALG$pull(ALG$state, trialsession)

            ### UPDATE Estimates ###
            ALG$state <- ALG$estimate(ALG$state, trialsession)

            ### ASSIGN workers ###
            ALG$state <- ALG$assign(ALG$state, trialsession)
        }
        # now save off the data we have accumulated
        filename = paste(ALG$state$name, rep, ".RData", sep="")
        STORE[[rep]] <- ALG$state
        save(STORE, file=filename)
    }
    rm(ALG)
#}
rm(STORE)
}

parLapply(cluster, ALGORITHMS, simulate)

stopCluster(cluster)
## FINISHED SIMULATIONS ##

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
    m1 = 0
    algnames = c()
    for (ALG in ALGORITHMS) {
        algname = ALG$state$name
        # append the name for use in the legend
        algnames = c(algnames, algname)
        # pull out the data
        DATA = grabData(ALG, algtrials)
        RESULTS[[algname]] <- DATA
        # find the greatest yield so we can format the yaxis nicely
        yield = max(DATA)
        if (yield > m1) {
            m1 = yield
        }
    }
    #m1 = max(NAIVE_DATA, EPSILON_DATA, BAYES_DATA)
    #legtext = c("Naive", "Epsilon-Greedy", "Bayes", "CERT BFF")
    #colours = c("black", "red", "blue", "green")
    colours = rainbow(length(ALGORITHMS))
    ylimit = ((m1 %/% 25) + 1) * 25

    ## ONE
    #postscript("simulation-cumm-crashes.ps")
    plot(RESULTS[[1]][1,],
         type='l',
         col = "white",
         main = "Stochastic Control Performance",
         xlab = "Iteration",
         xlim = c(0,duration),
         ylab = "Crashes",
         ylim = c(0,ylimit),
         lwd = 2)
    # Now plot all the trial data
    for (idx in 1:length(algnames)) {
        alg = algnames[idx]
        colour = colours[idx]
        for (t in 1:algtrials) {
            points(RESULTS[[idx]][t,],
                type = 'l',
                col = colour,
                lwd = 2)
        }
    }
    legend(x="topleft", algnames, col=colours, text.col=colours, pch=NA, lwd=4)
    grid()
    # abline(h=seq(0,ylimit,20),v=seq(0,duration,500),col="grey",lty=3)
    # dev.off()
}


