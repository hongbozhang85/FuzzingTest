# Slide 1
Introduce myself from ANU, supervisor and topic

# Slide 2
1. Shane has introduced what is fuzzing test 20 mins ago
2. There are lots of methods to improve the efficiency of fuzzing. such as optimizing corpus, optimizing mutation, optimizing scheduler and so on.
3. In this work, we will focus on *scheduler*
4. Especially, we will study the scheduler policy by simulation. since it is much cheaper than experiment, and provide a guideline for theory. 
5. We require a model in simulation to describe the underlying behavior of the fuzzing system. What we want is a bug model. However, building a bug model is much more difficult than crash model.
6. So in this work, we will work on crash model.
7. We will study *scheduler* by *simulation* with *crash model*.

# Slide 3
1. the most naive crash model is Bernoulli model, in which the node i means a state that already found i crashes and i can be infinite, and p is the probability to find a next crash.
2. the model is too simple that it has two disadvantage. one is it is impossible for a seed to trigger infinite unique crashes. The other one is probability to find a new unique crash should be decrease.
3. To overcome these two drawbacks, we improve the crash model, we call it limited crashes model. where, (all the parameters introduced)

# slide 4
1. using the limited crashes model, we make lots of simulation. left figure is a model with very very large n, the right is a model with n = 5
2. x-axis is the number of testing in a fuzzing. y-axis is the crashes found.
3. The red line is a theoretical upper bound. We can see that the purple line, follow the leader, in the left figure works best, in the right figure, it is not the case. FtL is a policy to maximum exploitation, and zero exploration.
4. the reason is that if n is very large, the crashes are so *rich* that exploration is *not* important. On the contrary, if n is small, the crashes is so few, that a balance between exploration and exploitation is required. 
5. Furthermore, there is a critical number n\*, which means the maximum average crashes found in a crash. n > n\*, the crash is rich and FtL works best,n < n\*, FtL doesn't. n\* is depending on model parameter and fuzzing setting.

# Slide 5
1. next, we will look into decay factor.
2. the left figure is \lambda = 0.3, FtL works best, on the right figure, \lambda = 0.9, FtL doesn't.
3. the reason is that crashes are expected to be found earlier for small lambda, hence favor more exploration.

# Slide 6
1. to see the competing between exploration and exploitation, we study a alphaUCB1 policy
2. in standard UCB1, there are two competing terms, mean and variance. mean represent exploitation, variance represent exploration
3. we improve this UCB1 to alphaUCB1, there is a multiplier here.so the larger alpha, the greater exploitation, the smaller alpha, the greater exploration. alpha -> infinity, it is FtL, completely exploitation, alpha =0, completely exploration.
4. so alpha is a parameter to describe the competing between exploration and exploitation. 
5. x-axis is alpha, y-axis is the ratio of finding crashes between alphaUCB1 and FtL.
5. we can see the result, for n >> n\*, completely exploitation is favored. for n < n\*, a balance between exploration and exploitation is required. 

# Slide 7
1. It is a story about exploration and exploration.
2. Therefore, accurate crashe modelling is essential in designing a scheduling policy.
