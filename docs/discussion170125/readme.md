
# 1 Parallel

+ [x] parallel the simulation code.  09 Dec 2016 (selected)
![test result figure](/home/admin-u6170245/SummerProject/cadets/parallel/sim-plot.png)


# 2 finite Markov Chain

## Bernoulli with Finite node (decay=1.0)

+ [x] algtrial = 10, decay = 1.0, active = 50, crash = 5 
![figure](/home/admin-u6170245/SummerProject/cadets/finiteBernoulli/a50/sim-plot.png)

## Active
number of active seed

+ [x] active = 50, algtrial = 10, 5 unique crashes. 16 Dec 2016 (selected)
![figure](/home/admin-u6170245/SummerProject/cadets/active/a50n5/sim-plot.png)

# 3 Discount factor
this parameter describe that the earlier a crash is found, the more value it will bring.
That is, we want find crashes as early as possible. active = 15, algtrial = 10, \infty unique crashes

decay = 0.9, result is different from 0.6 and 0.3

+ [x] decay = 0.3, other parameter are the same as previous (selected)
![figure](/home/admin-u6170245/SummerProject/cadets/discount/dis03/sim-plot.png)
+ [x] decay = 0.9, other parameter are the same as previous (selected)
![figure](/home/admin-u6170245/SummerProject/cadets/discount/dis09/sim-plot.png)


# 4 Algorithms


## UCB family

+ UCB1 infinite mclen
	+ [x] UCB1. algtrial = 10, others are the same as standard. AverageReward = Success/Trials
 	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1/sim-plot.png)
    + [x] UCB1_5. algtrial = 10, others are the same as standard. AverageReward = factor Success/Trials.
	  ***monotonically behavior***
      factor = 1, 10^2, 10^3, 10^4, 10^5, 10^6
	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1_5/sim-plot.png)
+ UCB1 finite mclen. algtrial = 10, active = 50, mclen  = 4 ( 5 unique crashes), others are the same as standard.
	+ [x] AverageReward = Success/Trials all other algorithms + UCB1 standard   /UCB1_finiteMC/1 
 	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1_finiteMC/1/sim-plot.png)
	+ [x] Averagereward = factor * Success/Trials. UCB1 only  /UCB1_finiteMC/2 ***non-monotonically behavior***
        UCB11=factor-1 UCB12=factor-100 UCB13=factor-1000 UCB14=factor-10000 UCB15=factor-100000 UCB16=factor-1000000 
 	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1_finiteMC/2/sim-plot.png)
+ UCB1 factor ~ n * relation.

## Time dependant epsilon-greed

+ [x] algtrial = 10, others are the same as standard. epsilon = 0.2 ~ 1.0 linearly with number of trials
 ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/vary_epsilon_greedy/sim-plot.png)
+ [x] algotrial = 10, active = 50, mclen = infinite, others are the same as standard. epsilon = 0.2 ~ 1 linearly with number of trials
 ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/vary_epsilon_greedy_2/sim-plot.png)
+ [x] algotrial = 10, active = 50, mclen = 4 (5 unique crashes), others are the same as standard. epsilon = 0.2 ~ 1 linearly with number of trials.
 ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/vary_epsilon_greedy_3/sim-plot.png)

# 5 R code to calculate Gittins index
+ [x] finite state space, off-line
+ [x] finite state space, on-line
+ [x] infinite state space, Bernoulli sampling process, Restart formulation

