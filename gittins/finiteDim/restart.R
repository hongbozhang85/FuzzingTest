# Restarting Formulation 
# one of on-line algorithm for computing gittins index
# finite but large dimension of state space, only one bandit
# see, Multi-Armed Bandits, Gittins Index, and Its Calculation Ch24.4 p429
# Hongbo Zhang


# problem settings

beta = 0.75		# discount factor
dim = 4   # dimension of state space
r = c(16,19,30,4)   # reward function of four state
P = matrix (	# transition matrix
			c(0.1, 0.0, 0.8, 0.1,
			  0.5, 0.0, 0.1, 0.4,
			  0.2, 0.6, 0.0, 0.2,
			  0.0, 0.8, 0.0, 0.2),
			nrow = 4, ncol = 4, byrow = TRUE)


#===========================

# return (ith state, its gittins index, its stopping set)
findGittins = function(i) {

		# calculate gittins index of the ith state
		Q0 = matrix (
					 rep(P[i,],dim),
					 nrow = 4, ncol = 4, byrow = TRUE)
		r0 = rep(r[i],dim)
		Q1 = P
		r1 = r

		vprevious = rep(0,dim)
		vafter = rep(1,dim)
		
		while ( sum(vafter - vprevious) > 10^-6 ) {
				vprevious = vafter
				vafter = pmax(r0 + beta * Q0 %*% vprevious, r1 + beta * Q1 %*% vprevious)
		}

		gittins = vafter[i] * (1-beta)

		# calculate the stopping set of the ith state
		temp1 = r0 + beta * Q0 %*% vafter
		temp2 = r1 + beta * Q1 %*% vafter
		set = 1:dim
		stopSet = set[temp1 >= temp2]
		
		# return
		thisResult = c(i,gittins, stopSet)
		return(thisResult)
}

#============================

#if ( exists("result")) {
		#rm(result)
#}

result = list()

for ( i in 1:dim ) {

		gittins = findGittins(i)

		result[[i]] = gittins

		#if ( exists("result")) {
				#result = list(result,gittins)
		#} else {
				#result = list(gittins)
		#}
}

#============================
print(result)
		

