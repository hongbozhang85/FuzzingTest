## Bayes implementation ##
# Author: Shane Magrath
# Author: Hongbo Zhang

funcInitBAYES = function() {
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
    state = list(name="Bayesian",
        filename="bayes.RData",
        SeedLambdas = Lambdas,
        Results = TrialResults,
        NumSuccess = rep(0,numseeds),
        NumTrials = rep(0,numseeds),
        WorkerAssignment = Assignment,
        SeedsFuzzed = rep(0,duration),
        EstimatedRates = Rates,
        noise = 0.1,
        isLowCost = TRUE,
		mclen = rep(0, numseeds) )
    return(state)
}

# pull the bandit arm
funcPullBAYES = function(state,trial) {
    #be nice to vectorise this
    for (worker in 1:numworkers) {
        seed = state$WorkerAssignment[worker]
        lambda = state$SeedLambdas[seed]
        # pull the arm  - One Bernoulli Trial
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
		#cat(state$SeedLambdas,"\n")
    }
    return(state)
}

funcEstimateBAYES = function(state, trial) {
    noise = state$noise
    if (trial < duration) {
        Success = state$NumSuccess
        Trials = state$NumTrials
        Estimate = (Success + noise) / (Trials + noise)
        state$EstimatedRates = Estimate
    }
    return(state)   
}

## worker assignment ## 
funcAssignBAYES = function(state, trial) {  
    # NOTE: we only switch workers every 'trialblock' iterations
    if (trial > 1) {
        if ((state$isLowCost) || (trial %% trialblock == 1)) {
            # 100 % turnover
            tasking = sample(1:numseeds, numworkers, replace=TRUE, prob=state$EstimatedRates)        
        } else {
            # everyone gets the same old assignment
            tasking = state$WorkerAssignment
        }
        state$WorkerAssignment = tasking
    }
    return(state)
}

### LIST ###
BAYES = list(state=funcInitBAYES(), init=funcInitBAYES, pull=funcPullBAYES, estimate=funcEstimateBAYES, assign=funcAssignBAYES)




