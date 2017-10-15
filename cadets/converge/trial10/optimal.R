## Optimal implementation ##
# Author: Shane Magrath

funcInitOPTIMAL = function() {
    # initialise the state
    # Assign workers to active seeds only
    Assignment = sample(1:active, numworkers, replace=TRUE)
    # Trial results
    TrialResults = rep(0,duration)
    # Latent true distribution for each seed
    Lambdas = rep(lambdalow,numseeds)
    Lambdas[1:active] = lambdahigh
    # create list structure
    state = list(name="OPTIMAL",
        filename="optimal.RData",
        SeedLambdas = Lambdas,
        Results = TrialResults,
        NumSuccess = rep(0,numseeds),
        NumTrials = rep(0,numseeds),
        WorkerAssignment = Assignment,
        SeedsFuzzed = rep(0,duration))
    return(state)
}

# pull the bandit arm
funcPullOPTIMAL = function(state,trial) {
    #be nice to vectorise this
    for (worker in 1:numworkers) {
        seed = state$WorkerAssignment[worker]
        lambda = state$SeedLambdas[seed]
        # pull the arm  - One Bernouli Trial
        result = sample(c(0,1), 1, replace = TRUE, prob = c(1 - lambda, lambda))
        state$NumTrials[seed] = state$NumTrials[seed] + 1
        if (result > 0) {
            state$NumSuccess[seed] = state$NumSuccess[seed] + result
            state$Results[trial] = state$Results[trial] + result
            lambda = lambda * exponentialdecay
            state$SeedLambdas[seed] = lambda
        }
    }
    return(state)
}

funcEstimateOPTIMAL = function(state, trial) {
    # our estimate is equivalent to reality
    state$EstimatedRates = state$SeedLambdas
    return(state)
}

## worker assignment ##
funcAssignOPTIMAL= function(state, trial) {
    # we assign workers according to our estimate (ie reality)
    tasking = sample(1:numseeds, numworkers, replace=TRUE, prob=state$EstimatedRates)
    state$WorkerAssignment = tasking
    return(state)
}

### LIST ###
OPTIMAL = list(state=funcInitOPTIMAL(),
               init=funcInitOPTIMAL,
               pull=funcPullOPTIMAL,
               estimate=funcEstimateOPTIMAL,
               assign=funcAssignOPTIMAL)




