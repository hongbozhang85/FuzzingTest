## "UCB 1" Implementation ##
# upper confidence bound 
# Chernoff-Hoeffding Bound 
# Averagereward = 1000 Success/Trials


funcInitUCB13 = function() {
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
    state = list(name="UCB1_factor-1000",
        filename="UCB13.RData",
        SeedLambdas = Lambdas,
        Results = TrialResults,
        NumSuccess = rep(0,numseeds),
        NumTrials = rep(0,numseeds),
        WorkerAssignment = Assignment,
        EstimatedRates = Rates,
        epsilon = 0.0,  # 0% exploration, 100% exploitation
        noise = 0.1,
		mclen = rep(0, numseeds) )
    return(state)
}

# pull the bandit arm
funcPullUCB13 = function(state,trial) {
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
	    	state$mclen[seed] = state$mclen[seed] + result
	    	if ( state$mclen[seed] > mclength ) {
				lambda = 0
			} else {
            	lambda = lambda * exponentialdecay 
			}
            state$SeedLambdas[seed] = lambda
        }
    }
    return(state)
}

funcEstimateUCB13 = function(state, trial) {
    noise = state$noise
    Success = state$NumSuccess
    Trials = state$NumTrials
    #Estimate = (Success + noise) / (Trials + noise)
    AverageReward = (Success + noise) / (Trials + noise)
	total = sum(Trials)
	Estimate = 1000*AverageReward + sqrt(2*log(total)/(Trials+noise))
    state$EstimatedRates = Estimate
    return(state)
}

## worker assignment ##
funcAssignUCB13 = function(state, trial) {
    if ((trial > 1) && (trial < duration)) {
        # first worker is randomly allocated a seed
        tasking = sample(1:numseeds, numworkers, replace=TRUE, prob=state$EstimatedRates)
        # find the best seed
        bestseed = which.max(state$EstimatedRates)
        # now randomly allocate an epsilon set of workers to the best seed
        # epsilon proportion are allocated to random search
        # (1-epsilon) prorportion are allocated to exploit
		# in UCB1 epsilon is always equals to 0, then every one in tasking should be the bestseed
        epsilon = state$epsilon
        greedy = sample(c(0,1), numworkers, replace = TRUE, prob = c(1-epsilon, epsilon))
        tasking[greedy == 0] = bestseed
        state$WorkerAssignment = tasking
    }
    return(state)
}

### LIST ###
UCB13 = list(state=funcInitUCB13(), init=funcInitUCB13, pull=funcPullUCB13, estimate=funcEstimateUCB13, assign=funcAssignUCB13)




