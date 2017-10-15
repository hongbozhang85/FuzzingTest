In order to imporve the efficiency of fuzzing test, the problem of scheduling policy is studied in the context of multi-armed bandit problem.
A new and more practical crash model in which finite unique crashes could be potentially triggered is investigated by simulation.
The simulation results show there exists a critial number n\* that depends on the crash model parameters and fuzzing campaign parameters.
The critial number represents the maximun expected number of crashes found in a fuzzing campaign.
For a crash model which can potentially trigger more than n\* crashes, being similar to the naive Bernoulli crash model,
follow the leader policy works best among all the policies used in the simulation.
However, if a crash model with crashes smaller than n\*, the follow the leader doesn't perform the optimal. 
Besides n\*, The effects of other model parameters are also discussed. They affect the scheduling policy in a none trival way.
This work figures that the scheduling problem in fuzzing test is complicated that the optimal policy will depend on the accurate
modelling the nature of crashes.

