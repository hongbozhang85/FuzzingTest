# Parallel

## Original

+ [x] repeat Shane's simulations.  08 Dec 2016
![simulation figure](/home/admin-u6170245/SummerProject/cadets/original/sim-plot.png)

## Parallel

+ [x] parallel the simulation code.  09 Dec 2016
![test result figure](/home/admin-u6170245/SummerProject/cadets/parallel/sim-plot.png)


# Converge

+ [x] algtrial = 5, see Section Parallel 
+ [x] algtrial = 10, it seems 10 is the same as 5.
![figure](/home/admin-u6170245/SummerProject/cadets/converge/trial10/sim-plot.png)

# Bernoulli with Finite node (decay=1.0)

+ [x] algtrial = 10, decay = 1.0, active = 15, crash = 5 
![figure](/home/admin-u6170245/SummerProject/cadets/finiteBernoulli/standard/sim-plot.png)
+ [x] algtrial = 10, decay = 1.0, active = 50, crash = 5 
![figure](/home/admin-u6170245/SummerProject/cadets/finiteBernoulli/a50/sim-plot.png)
+ [x] algtrial = 10, decay = 1.0, active = 50, crash = infinite 
![figure](/home/admin-u6170245/SummerProject/cadets/discount/a50/sim-plot.png)

# Active
number of active seed

+ [x] active = 15, algtrial = 10, see Section Parallel.
+ [x] active = 50, algtrial = 10, 3 unique crashes
![figure](/home/admin-u6170245/SummerProject/cadets/active/a50n3/sim-plot.png)
+ [x] active = 50, algtrial = 10, 5 unique crashes. 16 Dec 2016
![figure](/home/admin-u6170245/SummerProject/cadets/active/a50n5/sim-plot.png)
+ [x] active = 50, algtrial = 10, infinite(100000) unique crashes. 
![figure](/home/admin-u6170245/SummerProject/cadets/active/a50ninf/sim-plot.png)

# Discount factor
this parameter describe that the earlier a crash is found, the more value it will bring.
That is, we want find crashes as early as possible

decay = 0.9, result is different from 0.6 and 0.3

+ [x] decay = 0.6, active = 15, algtrial = 10, \infty unique crashes, see Section Parallel
+ [x] decay = 0.1, other parameter are the same as previous
![figure](/home/admin-u6170245/SummerProject/cadets/discount/dis01/sim-plot.png)
+ [x] decay = 0.3, other parameter are the same as previous
![figure](/home/admin-u6170245/SummerProject/cadets/discount/dis03/sim-plot.png)
+ [x] decay = 0.9, other parameter are the same as previous
![figure](/home/admin-u6170245/SummerProject/cadets/discount/dis09/sim-plot.png)
+ [x] decay = 1.0, other parameter are the same as previous. (Bernoulli case) 
![figure](/home/admin-u6170245/SummerProject/cadets/discount/dis1/sim-plot.png)


# Simulations

## Crash Model

### Crash Model 1: finite Markov Chain

for a given length of markov chain crash model, in the last node `\lambda = 1` 

***conjecture: active \times mclen matters. if active \times mclen>150, the result is the same as mclen=infinity***

+ [ ] test: in a infinite model, the typical number of unique crashes
+ [x] 2 unique crashes at most. (10 algtrial also done) 12 Dec 2016
 ![figure](/home/admin-u6170245/SummerProject/cadets/crashmodelN/N02/sim-plot.png)
+ [x] 3 unique crashes at most, 10 algtrial. 14 Dec 2016
 ![figure](/home/admin-u6170245/SummerProject/cadets/crashmodelN/N03_2/sim-plot.png)
+ [x] 4 unique crashes at most. 13 Dec 2016
 ![figure](/home/admin-u6170245/SummerProject/cadets/crashmodelN/N04/sim-plot.png)
+ [x] 5 unique crashes at most. 13 Dec 2016
 ![figure](/home/admin-u6170245/SummerProject/cadets/crashmodelN/N05/sim-plot.png)
+ [x] 8 unique crashes at most. 13 Dec 2016
 ![figure](/home/admin-u6170245/SummerProject/cadets/crashmodelN/N08/sim-plot.png)
+ [x] 10 unique crashes at most. 12 Dec 2016
 ![figure](/home/admin-u6170245/SummerProject/cadets/crashmodelN/N10/sim-plot.png)
+ [ ] 50 nodes

### Crash Model 1.5: finite Markov Chain with different length
The number of unique crashes triggered by a seed at most is finite, but different seeds will trigger different number of crashes.

### Crash Model 2:  discount parameter effect

+ [ ] exponentialdecay: 0.1
+ [ ] exponentialdecay: 0.3
+ [ ] exponentialdecay: 0.6
+ [ ] exponentialdecay: 0.9
+ [ ] exponentialdecay: 1.0

### Crash Model 3: truncted discount sequence
the first n node in Markov Chain will not decay (discount parameter is 1), but for nodes after n, the discount parameter is smaller than 1. This will reflect the fact that typical crashes finding in a seed is n, after finding n crashes, it become harder and harder to find a new unique crash.

### Crash Model 4: active seed number effect
change the active parameter

## Algorithms

### Least Failure Strategy
+ LFS algtrial = 10, others are the same as standard. Estimate = Trials - Success = Failure.
	I think this one will not be identical to UCB1_2. Since in UCB1_2, Success + UB ~ Success because of UB << Success. However, min(Failure) != max(Success).
	(Although min(Failure rate) = max(success rate) ). However, here is not the "rate".
 	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/lf/sim-plot.png)
	

### UCB family

+ UCB1 infinite mclen
	+ [x] UCB1. algtrial = 10, others are the same as standard. AverageReward = Success/Trials
 	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1/sim-plot.png)
	+ [x] UCB1_2. algtrial = 10, others are the same as standard. Averagereward = Success
	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1_2/sim-plot.png)
	+ [x] UCB1_3. algtrial = 10, others are the same as standard. AverageReward = 100 Success/Trials. 
	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1_3/sim-plot.png)
	+ [x] UCB1_4. algtrial = 10, others are the same as standard. AverageReward = 1000 Success/Trials. 
	  ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/UCB1_4/sim-plot.png)
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

### Time dependant epsilon-greed

+ [x] algtrial = 10, others are the same as standard. epsilon = 0.2 ~ 1.0 linearly with number of trials
 ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/vary_epsilon_greedy/sim-plot.png)
+ [x] algotrial = 10, active = 50, mclen = infinite, others are the same as standard. epsilon = 0.2 ~ 1 linearly with number of trials
 ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/vary_epsilon_greedy_2/sim-plot.png)
+ [x] algotrial = 10, active = 50, mclen = 4 (5 unique crashes), others are the same as standard. epsilon = 0.2 ~ 1 linearly with number of trials.
 ![figure](/home/admin-u6170245/SummerProject/cadets/algorithm/vary_epsilon_greedy_3/sim-plot.png)
+ ***find a optimal epsilon when mclen is finite***

### EXP family
### ERWMA
