# Largest Remaining Index algorithm
# one of off-line algorithm for computing gittins index
# finite but small dimension of state space, only one bandit
# see, Multi-Armed Bandits, Gittins Index, and Its Calculation Ch24.3 p419
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

# largest gittins index

result = rbind(c(which.max(r), r[which.max(r)]))

# recursion steps

for ( k in 1:(dim-1) ) {
		Q = P
		vec = 1:dim
		remove = ! vec %in% result[,1]
		Q[,remove] = 0
		temp = solve(diag(dim) - beta * Q)
		d = temp %*% r
		b = temp %*% rep(1,dim) 
		ind = d / b
		ind[!remove] = -1
		result = rbind( result, c(which.max(ind), ind[which.max(ind)]) )  #max(ind)) )
}

#==========================
# print result

colnames(result) = c("state","gittins-index")
print.table(result)

print.table(result[order(result[,1]),])




