
library(gbm)
library(MASS)

set.seed(130)
#Generate multivariate random data such that X1 is 
#moderetly correlated by X2, strongly
#correlated with X3, and not correlated with X4 or X5.
cov.m <- matrix(c(1,0.5,0.93,0,0,0.5,1,0.2,0,0,0.93,
	0.2,1,0,0,0,0,0,1,0,0,0,0,0,1), 5, 5, byrow=T)

# V1 = c(1, .5, .98, .05, .05)
# V2 = c(.5, 1, .2, 1e-6, 1e-6)
# V3 = c(.98, .2, 1, 1e-6, 1e-6)
# V4 = c(.05, 1e-6, 1e-6, 1, 1e-6)
# V5 = c(.05, 1e-6, 1e-6, 1e-6, 1)

#cov.m = rbind(V1, V2, V3, V4, V5)
#cov.m = data.matrix(cov.m)
# cov.m = matrix(NA, nrow=5, ncol=5)
# cov.m[1,] = cor1
# cov.m[2,] = cor2
# cov.m[3,] = cor3
# cov.m[4,] = cor4
# cov.m[5,] = cor5
# cov.m = t(cov.m)*cov.m

#TODO: add duplicated variable
#add several more ind variables

n <- 2000 # obs
X <- mvrnorm(n, rep(0, 5), Sigma=cov.m)
Y <- apply(X, 1, sum)
SNR <- 10 # signal-to-noise ratio
sigma <- sqrt(var(Y)/SNR)
Y <- Y + rnorm(n,0,sigma)
mydata <- data.frame(X,Y)

#Fit Model (should take less than 20 seconds on an average modern computer)
gbm1 <- gbm(formula = Y ~ X1 + X2 + X3 + X4 + X5,
					data=mydata, distribution = "gaussian",
					n.trees = 1000, interaction.depth = 4,
					n.minobsinnode = 10, shrinkage = 0.05,
					bag.fraction = 0.5, train.fraction = 1,
					cv.folds=5, keep.data = TRUE,
					verbose = F)
## Plot variable influence
best.iter <- gbm.perf(gbm1, plot.it = T, method="cv")
print(best.iter)
# based on the estimated best number oftrees
summary(gbm1,n.trees=best.iter)

Xtest = mvrnorm(n, rep(0,5), cov.m)
Ytest = apply(Xtest, 1, sum)
Ytest = Ytest + rnorm(n, 0, sigma)
mydataTest = data.frame(Xtest, Ytest)
pred = predict(gbm1, newdata=mydataTest)

sqrt((Ytest-pred)^2)



###################

set.seed(20)
n <- 100
p <- 10

data <- as.data.frame(matrix(rnorm(n*(p-1)), nrow = n))
data$V10 <- data$V9
data$V11 = data$V10 + rnorm(nrow(data), 0, .1)
data = data[,-match("V9", names(data))]

#data$y <- 2 + 4 * data$dup - 2 * data$dup^2 + rnorm(n)
data$y = 2 + 4 * data$V11 - 2 * data$V11^2 + rnorm(n)

data <- data[, sample(1:ncol(data))]
#str(data)

fit <- gbm(y~., data = data, distribution = "gaussian",
        interaction.depth = 10, n.trees = 100,
        verbose = FALSE)
summary(fit)


##################

library(mlbench)
data(Ozone)

set.seed(270)

mydata = Ozone[,-9]
mydata = mydata[complete.cases(mydata),]

mydata$V14 = mydata$V8 + rnorm(nrow(mydata), 0, sd=1)
mydata$V15 = mydata$V8 + rnorm(nrow(mydata), 0, sd=1)
mydata$V16 = mydata$V8 + rnorm(nrow(mydata), 0, sd=1)
mydata$V17 = mydata$V8 + rnorm(nrow(mydata), 0, sd=1)
mydata$V18 = as.numeric(mydata$V2) + 
  rnorm(nrow(mydata), 0, sd=1)
mydata$V19 = as.numeric(mydata$V2) + 
  rnorm(nrow(mydata), 0, sd=1)
mydata$V20 = as.numeric(mydata$V2) + 
  rnorm(nrow(mydata), 0, sd=1)
mydata$V21 = mydata$V12 + rnorm(nrow(mydata), 0, sd=1)
mydata$V22 = mydata$V12 + rnorm(nrow(mydata), 0, sd=1)
mydata$V23 = mydata$V12 + rnorm(nrow(mydata), 0, sd=1)
mydata$V24 = mydata$V12 + rnorm(nrow(mydata), 0, sd=1)

idx = 1:nrow(mydata)
idxTest = sample(1:nrow(mydata),size=100)
idxTrn = idx[!idx%in%idxTest]
mydataTrn = mydata[idxTrn,]
mydataTest = mydata[idxTest,]

gbm1 <- gbm(formula = V4~.,
          data=mydataTrn, distribution = "gaussian",
          n.trees = 1800, interaction.depth = 7,
          n.minobsinnode = 10, shrinkage = 0.01,
          bag.fraction = 0.5, train.fraction = 1,
          cv.folds=5, keep.data = F,
          verbose = F)

best.iter <- gbm.perf(gbm1, plot.it = F, method="cv")
# based on the estimated best number oftrees
summary(gbm1,n.trees=best.iter)

pred = predict(gbm1, newdata=mydataTest)

sqrt(sum((mydataTest$V4-pred)^2))





fit <- lm(V4~., data=mydata)
step <- stepAIC(fit, direction="both")

step$anov





