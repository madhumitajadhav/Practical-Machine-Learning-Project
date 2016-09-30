library(caret)
library(rpart)
library(e1071)
library(rpart.plot)
library(RColorBrewer)
library(randomForest)

# Reading file from source
training1 <- read.csv("D:/My Stuff/Practical Machine learning/pml-training.csv", na.strings=c("NA","#DIV/0!",""))
testing1 <- read.csv("D:/My Stuff/Practical Machine learning/pml-testing.csv", na.strings=c("NA","#DIV/0!",""))

# Removing columns which contains NAs and Null Values
training1<-training1[,-c(12:36,50:59,69:83,87:101,103:112,125:139,141:150)]
testing1<-testing1[,-c(12:36,50:59,69:83,87:101,103:112,125:139,141:150)]

# removed column "new_window" and "X"
training1<-training1[,-c(1,6)]
# creating folds of training data for prediction 
inTrain <- createDataPartition(y=training1$classe, p=0.6, list=FALSE)
myTraining1 <- training1[inTrain, ]
myTesting1 <- training1[-inTrain, ]

clean1 <- colnames(myTraining1)
# Remove "classe" column 
clean2 <- colnames(myTraining1[, -58])  
myTesting1 <- myTesting1[clean1]
testing1 <- testing1[clean2]


for (i in 1:length(testing1) ) {
  for(j in 1:length(myTraining1)) {
    if( length( grep(names(myTraining1[i]), names(testing1)[j]) ) ==1)  {
      class(testing1[j]) <- class(myTraining1[i])
    }      
  }      
}

testing1 <- rbind(myTraining1[2, -58] , testing1)
testing1 <- testing1[-1,]


######## Decision Tree #########

modFitA11 <- rpart(classe ~ ., data=myTraining1, method="class")
#fancyRpartPlot(modFitA1)
predictionsA11 <- predict(modFitA11, myTesting1, type = "class")
confusionMatrix(predictionsA11, myTesting1$classe)
predictionsA21 <- predict(modFitA11, testing1, type = "class")

######## randomForest #########

modFitB11 <- randomForest(classe ~. , data=myTraining1)
predictionsB11 <- predict(modFitB11, myTesting1, type = "class")
confusionMatrix(predictionsB11, myTesting1$classe)
predictionsB21 <- predict(modFitB11, testing1, type = "class")

######### SVM #########
SVM_model1 <- svm(classe ~. , data=myTraining1,probability = TRUE)
predictionsC11 <- predict(SVM_model1, myTesting1, type = "class")
confusionMatrix(predictionsC11, myTesting1$classe)
predictionsC21 <- predict(SVM_model1, testing1, type = "class")

------------------------------------------------------------
predictionsA21
# 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
# B  A  C  A  A  E  D  C  A  A  B  C  B  A  E  E  A  B  B  B 

------------------------------------------------------------
predictionsB21
# 1  2  3  4 51  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
# B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
------------------------------------------------------------
predictionsC21
# 1  2  3  4 51  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
# B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 


-------------------------------------------------------------------
## Out Of sample Error For Decision Tree
outOfSampleError.accuracy <- sum(predictionsA11 == myTesting1$classe)/length(predictionsA11)
outOfSampleError.accuracy

# out of sample error and percentage of out of sample error
outOfSampleError <- 1 - outOfSampleError.accuracy
outOfSampleError

e <- outOfSampleError * 100
paste0("Out of sample error estimation: ", round(e, digits = 2), "%")
-------------------------------------------------------------------
## Out Of sample Error For Random Forest
outOfSampleError.accuracy <- sum(predictionsB11 == myTesting1$classe)/length(predictionsB11)
outOfSampleError.accuracy

# out of sample error and percentage of out of sample error
outOfSampleError <- 1 - outOfSampleError.accuracy
outOfSampleError

e <- outOfSampleError * 100
paste0("Out of sample error estimation: ", round(e, digits = 2), "%")
-------------------------------------------------------------------

## Out Of sample Error For SVM
outOfSampleError.accuracy <- sum(predictionsC11 == myTesting1$classe)/length(predictionsC11)
outOfSampleError.accuracy

# out of sample error and percentage of out of sample error
outOfSampleError <- 1 - outOfSampleError.accuracy
outOfSampleError

e <- outOfSampleError * 100
paste0("Out of sample error estimation: ", round(e, digits = 2), "%")
#-------------------------------------------------------------------









