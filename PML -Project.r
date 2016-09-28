
library(caret)
library(rpart)
library(rpart.plot)
library(RColorBrewer)
library(randomForest)

set.seed(12345)


training <- read.csv("D:/My Stuff/Practical Machine learning/pml-training.csv", na.strings=c("NA","#DIV/0!",""))
testing <- read.csv("D:/My Stuff/Practical Machine learning/pml-testing.csv", na.strings=c("NA","#DIV/0!",""))

inTrain <- createDataPartition(y=training$classe, p=0.6, list=FALSE)
myTraining <- training[inTrain, ]
myTesting <- training[-inTrain, ]

dim(myTraining) 
dim(myTesting)

myDataNZV <- nearZeroVar(myTraining, saveMetrics=TRUE)
dim(myDataNZV)

myNZVvars <- names(myTraining) %in% c("new_window", "kurtosis_roll_belt", "kurtosis_picth_belt",
                                      "kurtosis_yaw_belt", "skewness_roll_belt", "skewness_roll_belt.1", "skewness_yaw_belt",
                                      "max_yaw_belt", "min_yaw_belt", "amplitude_yaw_belt", "avg_roll_arm", "stddev_roll_arm",
                                      "var_roll_arm", "avg_pitch_arm", "stddev_pitch_arm", "var_pitch_arm", "avg_yaw_arm",
                                      "stddev_yaw_arm", "var_yaw_arm", "kurtosis_roll_arm", "kurtosis_picth_arm",
                                      "kurtosis_yaw_arm", "skewness_roll_arm", "skewness_pitch_arm", "skewness_yaw_arm",
                                      "max_roll_arm", "min_roll_arm", "min_pitch_arm", "amplitude_roll_arm", "amplitude_pitch_arm",
                                      "kurtosis_roll_dumbbell", "kurtosis_picth_dumbbell", "kurtosis_yaw_dumbbell", "skewness_roll_dumbbell",
                                      "skewness_pitch_dumbbell", "skewness_yaw_dumbbell", "max_yaw_dumbbell", "min_yaw_dumbbell",
                                      "amplitude_yaw_dumbbell", "kurtosis_roll_forearm", "kurtosis_picth_forearm", "kurtosis_yaw_forearm",
                                      "skewness_roll_forearm", "skewness_pitch_forearm", "skewness_yaw_forearm", "max_roll_forearm",
                                      "max_yaw_forearm", "min_roll_forearm", "min_yaw_forearm", "amplitude_roll_forearm",
                                      "amplitude_yaw_forearm", "avg_roll_forearm", "stddev_roll_forearm", "var_roll_forearm",
                                      "avg_pitch_forearm", "stddev_pitch_forearm", "var_pitch_forearm", "avg_yaw_forearm",
                                      "stddev_yaw_forearm", "var_yaw_forearm")


myTraining <- myTraining[!myNZVvars]

dim(myTraining)

myTraining <- myTraining[c(-1)]

trainingV3 <- myTraining #creating another subset to iterate in loop
for(i in 1:length(myTraining)) { #for every column in the training dataset
  if( sum( is.na( myTraining[, i] ) ) /nrow(myTraining) >= .6 ) { #if n?? NAs > 60% of total observations
    for(j in 1:length(trainingV3)) {
      if( length( grep(names(myTraining[i]), names(trainingV3)[j]) ) ==1)  { #if the columns are the same:
        trainingV3 <- trainingV3[ , -j] #Remove that column
      }   
    } 
  }
}

dim(trainingV3)


myTraining <- trainingV3
rm(trainingV3)


clean1 <- colnames(myTraining)
clean2 <- colnames(myTraining[, -58]) #already with classe column removed
myTesting <- myTesting[clean1]
testing <- testing[clean2]


dim(myTesting)
dim(testing)

for (i in 1:length(testing) ) {
  for(j in 1:length(myTraining)) {
    if( length( grep(names(myTraining[i]), names(testing)[j]) ) ==1)  {
      class(testing[j]) <- class(myTraining[i])
    }      
  }      
}


testing <- rbind(myTraining[2, -58] , testing) #note row 2 does not mean anything, this will be removed right.. now:
testing <- testing[-1,]


# train(rpart)
modFitD1 <- train(classe ~ ., data=myTraining, method="rpart")
predictionsD1 <- predict(modFitD1, myTesting)
confusionMatrix(predictionsA1, myTesting$classe)
predictionsD2 <- predict(modFitD1, testing)
predictionsD2

# train(rf)
modFitE1 <- train(classe ~ ., data=myTraining, method="rf")
predictionsE1 <- predict(modFitE1, myTesting)
confusionMatrix(predictionsE1, myTesting$classe)
predictionsE2 <- predict(modFitE1, testing)
predictionsE2

########Decision Tree

modFitA1 <- rpart(classe ~ ., data=myTraining, method="class")
#fancyRpartPlot(modFitA1)
predictionsA1 <- predict(modFitA1, myTesting, type = "class")
confusionMatrix(predictionsA1, myTesting$classe)
predictionsA2 <- predict(modFitA1, testing, type = "class")

########randomForest

modFitB1 <- randomForest(classe ~. , data=myTraining)
predictionsB1 <- predict(modFitB1, myTesting, type = "class")
confusionMatrix(predictionsB1, myTesting$classe)
predictionsB2 <- predict(modFitB1, testing, type = "class")

######### SVM
SVM_model <- svm(classe ~. , data=myTraining,probability = TRUE)
predictionsC1 <- predict(SVM_model, myTesting, type = "class")
confusionMatrix(predictionsC1, myTesting$classe)
predictionsC2 <- predict(SVM_model, testing, type = "class")

# DECISION TREE #
predictionsA2
# 3  2 31  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
# A  A  C  A  A  E  D  C  A  A  B  C  B  A  E  E  A  B  B  B 

# RANDOM FOREST #
predictionsB2
# 1  2 31  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
# B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 

# svm #
predictionsC2
# 3  2 31  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
# A  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 

#train(rpart)
predictionsD2
# 3  2 31  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
# A  A  C  A  C  C  C  C  A  A  A  C  C  A  C  C  A  A  A  C



