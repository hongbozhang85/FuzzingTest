### Calculate the Gittins Indices for the Bernoulli Bandit Process ###
##
## Reference: See "MultiArmed Bandit Allocation Indices", Gittins et. al.
##            Section 8.4, Equation 1.6 and Table 8.8
## -- Shane Magrath

## Parameters
DCF = 0.99 # discount rate
FH = 750 # This is the "frontier horizon" beyond which we rollup
N = FH - 1 # Matrix size is N * N
DELTA = 0.0001 # step size in Gittin's index

######################################################
Reward<- matrix(0.0, nrow = N, ncol = N) # Expected Reward(a,b) values
GittinsIndex <- matrix(0.0, nrow = N, ncol = N) # Gittin's Indices

START = Sys.time()

# True if two points are within epsilon of each other
TolerablyEqual <- function(p1, p2, epsilon) {
    isEqual = FALSE
    if (abs((p1 - p2)) < epsilon) {
        isEqual = TRUE
    }
    return (isEqual)
}

# Initialise the "frontier horizon endpoints" - these are the starting points
# for backwards induction
for (a in 1:N) {
    b = FH - a  # 1 <= b <= N
    Reward[a,b] = (1.0 * a) / (1.0 * FH) # init with E[X(a,b)] which is a/(a+b)
}

# Main Loop
iter = 1
for (p in seq(from = DELTA / 2, to = 1, by = DELTA)) {
    cat(paste('Iteration: ', iter, ', p: ', p, '\n'))
    # "safe value" is the "offer" to stop playing the bandit. It represents the
    # case where we know with certainty that the safe choice pays out with
    # probability p. This is simply the expected sum of future discounted
    # "cash flows".
    # The point at which this offer exceeds the risky option of continuing to
    # play the bandit gives us the Gittins Index.
    safe = p / (1 - DCF)
    for (diagonal in seq(from=N, to = 2, by = -1)) {
        for (a in 1:(diagonal-1)) {
            b = diagonal - a
            # "risky value" is the expected value of continuing to play the
            # bandit forever given our current state (a,b). We can estimate
            # this value using the Bellman recurrence equation which simply
            # computes the current value of the state as the sum of the
            # expected value of each possible future state along with any
            # "cash flows" arising from state transitions. To deal with the
            # issue of infinite time horizons we can replace these distant
            # infinite series - those that extend beyond time step FH - with an
            # upper bound estimate of the value of these states which is simply
            # the expected value of the state E[X] = a/G[FH. By the time we
            # apply the discount factor DCF^(N-1) to these states the actual
            # error in the estimate is small and controllable.
            risky = (a / diagonal) * (1 + DCF * Reward[(a + 1),b]) +
                    (b / diagonal) * (0 + DCF * Reward[a,(b + 1)])
            # We are looking for the crossover point where "safe" exceeds "risky"
            # for the first time.
            if (TolerablyEqual(GittinsIndex[a,b], 0.0, 0.00001) &&
                (safe > risky)) {
                # The estimated Gittins index is the midpoint between the
                # current and last p value.
                GittinsIndex[a,b] = (p - DELTA / 2)
#                 cat(
#                     paste(
#                         '\tDONE: a=', a,
#                         ', b=', b,
#                         ', diagonal=', diagonal,
#                         ', safe=', safe,
#                         ', risky=', risky,
#                         ', GittinsIndex[a,b]=', GittinsIndex[a,b],
#                         '\n'
#                     )
#                 )
            }
            # update the estimate for the value of the current state. This is
            # simply the value of your best choice between safe and risky.
            Reward[a,b] = max(safe,risky)
        }
    }
    iter = iter + 1
}
###########################################################
END = Sys.time()
ELAPSED = END - START
cat(paste('Elapsed Time is ', ELAPSED,'\n'))
# Done - write out data
outf = file('gittinsindex.csv','wb')
cat('Gittins Indices for Bernoulli Bandit Process\n', file=outf)
cat(paste('\tDiscount Factor: ', DCF, '\n'),file=outf)
cat(paste('\tFrontier Horizon: ', FH, '\n'),file=outf)
cat(paste('\tDelta: ', DELTA, '\n'),file=outf)
cat('Rows are alpha, Columns are beta. \n', file=outf)
cat(paste('Elapsed Time is ', ELAPSED, ' seconds (',HOURS, ' hours)\n'), file = outf)
cat('\n', file=outf)
write.table(
    GittinsIndex,
    file = outf,
    sep = ',',
    col.names = FALSE, row.names = FALSE
)
close(outf)