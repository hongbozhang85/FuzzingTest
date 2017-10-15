# Restarting Formulation
# computing gittins index for Bernoulli sampling processes
# only one bandit.
# output m(0,0) tabulated with (a+s, b+f)
# see, Computing Optimal Sequential Allocation Rules in Clinical Trials, M. Katehakis, C. Derman
# Hongbo Zhang


#== problem settings==

# one point in the table
beta = 0.5	# discount factor
as = 1	# prior parameter of sucess in Beta(a,b)
bf = 1	# prior parameter of failure in Beta(a,b)
		# actually, the (a,b) here is (a+s, b+f)
L = 10 # truncted length, i.e., s+f \leq L
epsilon = 10^-4 # the tolerance in finding fix point of operator T1 and T2

# for a given beta, loop a and b in function findgittins(a,b,L) to get the 2-dim table. change L correspondinglly

# example shown at the end of this file

#===utils======

# map (x,y)|{x>0,y>0,x+y<l} pair to [1,(l+1)(l+2)/2]. 
# e.g. (0,0)->1, (1,0)->2, (0,1)->3, (2,0)->4, (1,1)->5,(0,2)->6, ...
#   | 0  1  2  ...
#----------------
# 0 | 1  3  6
# 1 | 2  5
# 2 | 4
#...
indexMap2to1 = function(x,y) {
		l = x + y
		base = l*(l+1)/2
		ind = base + y + 1
		return(ind)
}

# inverse function of indexMap2to1
indexMap1to2 = function(ind) {
		i = 0
		while ( ind > (i+1)*(i+2)/2 ) {
				i = i+1
		}
		y = ind - i*(i+1)/2 - 1
		x = i - y
		return( c(x,y))
}


# two real number equal within tolerance epsilon. i.e., |x-y|<eps, return true
realNumberEqual = function(x,y,eps) {
		isEqual = FALSE;
		if ( abs(x-y) < eps ) {
				isEqual = TRUE
		}
		return(isEqual)
}

# get the number of elements in upper triangle 0:l
numberElements = function (l) {
		return ( (l+1)*(l+2)/2 )
}

#======= Main part ============

OperatorT1 = function(uL,a,b) {
		l = L
		uLNew = 0
		for ( i in 1:numberElements(l) ) { 
				s = indexMap1to2(i)[1]
				f = indexMap1to2(i)[2]
				if ( (s+f) < l ) {
						temp1 = a/(a+b) + beta*a/(a+b)*uL[2] + beta*b/(a+b)*uL[3]
						indNew1 = indexMap2to1(s+1,f) 
						indNew2 = indexMap2to1(s,f+1) 
						temp2 = (a+s)/(a+s+b+f) + beta*(a+s)/(a+s+b+f)*uL[indNew1] + beta*(b+f)/(a+s+b+f)*uL[indNew2]
						uLNew[i] = pmax(temp1,temp2)
				} else if ( (s+f) == l ) {
						uLNew[i] = (a+s)/(a+s+b+f)/(1-beta)
				} else {
						print("s+f>L")
						break
				}
		}
		return(uLNew)
}


OperatorT2 = function(UL,a,b) {
		l = L	
		ULNew = 0
		for ( i in 1:numberElements(l) ) { 
				s = indexMap1to2(i)[1]
				f = indexMap1to2(i)[2]
				if ( (s+f) < l ) {
						temp1 = a/(a+b) + beta*a/(a+b)*UL[2] + beta*b/(a+b)*UL[3]
						indNew1 = indexMap2to1(s+1,f) 
						indNew2 = indexMap2to1(s,f+1) 
						temp2 = (a+s)/(a+s+b+f) + beta*(a+s)/(a+s+b+f)*UL[indNew1] + beta*(b+f)/(a+s+b+f)*UL[indNew2]
						ULNew[i] = pmax(temp1,temp2)
				} else if ( (s+f) == l ) {
						ULNew[i] = 1/(1-beta)
				} else {
						print("s+f>L")
						break
				}
		}
		return(ULNew)
}


findGittins = function(a,b,l) {
		# initialize the uL and UL for recursion
		UL = rep(1/(1-beta), numberElements(l))
		uL = 0
		for ( i in 1:numberElements(l) ) {
			s = indexMap1to2(i)[1]
			f = indexMap1to2(i)[2]
			uL[i] = (a+s)/(a+s+b+f)/(1-beta)
		}		
		# recursion to find fix point of operator T1
		uLPrevious = rep(-1, numberElements(l)) 
		while ( ! realNumberEqual(sum(uLPrevious),sum(uL),epsilon) ) {
				uLPrevious = uL
				uL = OperatorT1(uLPrevious,a,b)
		}
		# recursion to find fix point of operator T2
		ULPrevious = rep(-1, numberElements(l))
		while ( ! realNumberEqual(sum(ULPrevious),sum(UL),epsilon) ) {
				ULPrevious = UL
				UL = OperatorT1(ULPrevious,a,b)
		}
		# find arthemic average of uL[1] and UL[1] as the gittins index m(0,0)
		if ( realNumberEqual(uL[1],UL[1],epsilon) ) {
			gittins = (uL[1] + UL[1])/2
			return (gittins)
		} else {
				print("difference between uL and UL is too large, please increase truncted length L")
		}
}

#=======debug=========

result = findGittins(a,b,L)
print(result)

as = 10
bf = 10
gittinsTable = matrix( 0, nrow = as, ncol = bf)
for ( xx in 1:as ) {
		for ( yy in 1:bf ) {
				gittinsTable[xx,yy] = findGittins(xx,yy,L)
		}
}

	
