## Naive implementation ##
# Author: Shane Magrath
# Author: Hongbo Zhang

funcInitNAIVE = function() {
    # initialise the state
    # first trial is randomly assigned to avoid any bias effects
    Assignment = sample(1:numseeds, numworkers, replace=TRUE) 
    # Trial results 
    TrialResults = rep(0,duration)
    # Latent true distribution for each seed
    Lambdas = rep(lambdalow,numseeds)
    Lambdas[1:active] = lambdahigh
    # create list structure
    state = list(name="Naive",
        filename="naive.RData",
        SeedLambdas = Lambdas,
        Results = TrialResults,
        NumSuccess = rep(0,numseeds),
        NumTrials = rep(0,numseeds),
        WorkerAssignment = Assignment,
	    mclen = rep(0, numseeds)	)
    return(state)
}

# pull the bandit arm
funcPullNAIVE = function(state,trial) {
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
		#cat(state$SeedLambdas,"\n")
    }
    return(state)
}

funcEstimateNAIVE = function(state, trial) {
    # we don't do any estimates in this strategy
    return(state)   
}

## worker assignment ## 
funcAssignNAIVE = function(state, trial) {  
    # tasking is simple uniform random sampling
    if (trial < duration)  {
        tasking = sample(1:numseeds, numworkers, replace=TRUE) 
        state$WorkerAssignment = tasking
    }
    return(state)
}

### LIST ###
NAIVE = list(state=funcInitNAIVE(), init=funcInitNAIVE, pull=funcPullNAIVE, estimate=funcEstimateNAIVE, assign=funcAssignNAIVE)




