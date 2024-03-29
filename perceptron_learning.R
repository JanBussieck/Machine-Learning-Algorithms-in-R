#implements the learning algorithm for a set of training patterns
perceptronLearning <- function(trainingPattern) {
  dim <- ncol(trainingPattern) #dimension of training vectors 
  weight <- runif(dim) #weight vector contains threshold as its first value
  trainingPattern <- cbind(rep(1, nrow(trainingPattern)), trainingPattern) #add 1 as weight for the threshold to every training Vector
  correct <- FALSE #flag indicating whether all patterns have been correctly recognized
  measures <- matrix(nrow=0, ncol=2) #table for precision and recall measures
  
  #figures for recall and precision measures
  tp <- 0
  fp <- 0
  fn <- 0
  lastAvgRecall <- 0
  lastAvgPrecision <- 0
  
  #do the actual iterations
  while (!correct) { #repeat, until all patterns are correctly recognized
      correct <- TRUE
      tps <- c()
      
      #iterate over every training pattern. Adjust weights, if necessarya
      for (i in 1:nrow(trainingPattern)) {
        x <- unlist(trainingPattern[i, 1:dim])
        r <- weight %*% x
        
        #check result. Adjust weights, if necessary
        if (trainingPattern[i, dim+1] == 1 && r <= 0) {#incorrect: patterin is positive, result is negative (false negative)
          correct <- FALSE
          weight <- weight + x
          fn <- fn + 1
        } else if (trainingPattern[i,dim+1] == 0 && r > 0) { #pattern is negative, but result is positive (false positive)
          correct <- FALSE
          weight <- weight - x
          fp <- fp + 1
        } else if (r > 0) { #true positive 
          tp <- tp + 1
        }
        
        #Calculate measures for this iteration and add to the matrix
        recall <- tp / (tp + fn)
        precision <- tp / (tp + fp)
        measures <- rbind(measures, c(recall, precision))
      } 
      
      #measure the average recall and precision. Stop learning, if the average measures do not increase after 10 iterations of the outer loop
      avgRecall <- mean(measures[,1], na.rm = TRUE)
      avgPrecision <- mean(measures[,2], na.rm = TRUE)
      if(avgRecall <= lastAvgRecall && avgPrecision <= lastAvgPrecision && t > 10) {
        stop("Does not converge")
      } else {
        lastAvgRecall <- avgRecall
        lastAvgPrecision <- avgPrecision
      }
  }

  #return the learned weights and measures
  names(weight) = c("Threshold", 1:(length(weight)-1))
  return(list(weight, measures))
}

#load data sets into memory
set1 <- read.table("./set1.txt")
set2 <- read.table("./set2.txt")
set3 <- read.table("./set3.txt")

#Start learning, print resulting weight vectors and plot the measures
try({
result1 <- perceptronLearning(set1)
print("Optimal weights for the first set:")
print(result1[[1]])
plot(result1[[2]], type="p", main="Recall and Precision - Set 1", xlab="Recall", ylab="Precision")
})

try({
result2 <- perceptronLearning(set2)
print("Optimal weights for the second set:")
print(result2[[1]])
plot(result2[[2]], type="p", main="Recall and Precision - Set 2", xlab="Recall", ylab="Precision")
})

try({
result3 <- perceptronLearning(set3)
print("Optimal weights for the third set:")
print(result3[[1]])
plot(result3[[2]], type="p", main="Recall and Precision - Set 3", xlab="Recall", ylab="Precision")
})