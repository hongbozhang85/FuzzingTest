## "Follow The Leader" Implementation ##
# NOTE: The traditional epsilon-greedy algorithm has only a
# single worker pulling bandit arms. In our case we have
# many workers. We have adapted the algorithm accordingly.


funcInitFTL = function() {
    # initialise the state
    Rates = rep(1 / numseeds, numseeds) # assume uniform prior
    # first trial is randomly assigned to avoid any bias effects
    Assignment = sample(1:numseeds, numworkers, replace=TRUE)
    # Trial results
    TrialResults = rep(0,duration)
    # Latent true distribution for each seed
    Lambdas = rep(lambdalow,numseeds)
    Lambdas[1:active] = lambdahigh
    # create list structure
    state = list(name="Follow-The-Leader",
        filename="FTL.RData",
        SeedLambdas = Lambdas,
        Results = TrialResults,
        NumSuccess = rep(0,numseeds),
        NumTrials = rep(0,numseeds),
        WorkerAssignment = Assignment,
        EstimatedRates = Rates,
        epsilon = 0.0,  # 0% exploration, 100% exploitation
        noise = 0.1 )
    return(state)
}

# pull the bandit arm
funcPullFTL = function(state,trial) {
    #be nice to vectorise this
    for (worker in 1:numworkers) {
        seed = state$WorkerAssignment[worker]
        lambda = state$SeedLambdas[seed]
        # pull the arm  - One Bernouuli Trial
        result = sample(c(0,1), 1, replace = TRUE, prob = c(1 - lambda, lambda))
        state$NumTrials[seed] = state$NumTrials[seed] + 1
        if (result > 0) {
            state$NumSuccess[seed] = state$NumSuccess[seed] + result
            state$Results[trial] = state$Results[trial] + result
            lambda = lambda * exponentialdecay # heisendecay
            state$SeedLambdas[seed] = lambda
        }
    }
    return(state)
}

funcEstimateFTL = function(state, trial) {
    noise = state$noise
    Success = state$NumSuccess
    Trials = state$NumTrials
    Estimate = (Success + noise) / (Trials + noise)
    state$EstimatedRates = Estimate
    return(state)
}

## worker assignment ##
funcAssignFTL = function(state, trial) {
    if ((trial > 1) && (trial < duration)) {
        # first worker is randomly allocated a seed
        tasking = sample(1:numseeds, numworkers, replace=TRUE, prob=state$EstimatedRates)
        # find the best seed
        bestseed = which.max(state$EstimatedRates)
        # now randomly allocate an epsilon set of workers to the best seed
        # epsilon proportion are allocated to random search
        # (1-epsilon) prorportion are allocated to exploit
        epsilon = state$epsilon
        greedy = sample(c(0,1), numworkers, replace = TRUE, prob = c(1-epsilon, epsilon))
        tasking[greedy == 0] = bestseed
        state$WorkerAssignment = tasking
    }
    return(state)
}

### LIST ###
FTL = list(state=funcInitFTL(), init=funcInitFTL, pull=funcPullFTL, estimate=funcEstimateFTL, assign=funcAssignFTL)




