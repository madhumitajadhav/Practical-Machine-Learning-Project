# Practical-Machine-Learning-Project
This contains final Practical Machine Learning program file

Files used:
  1)plm_training
  2)plm_testing
 
 This file contains 160 variables and 19622 rows 
 Here we want to predict the classe of the particular user based on features. 
 
 Steps that I have followed:
 
 1) Data Cleaning (Remove Columns): In the file there are 160 variables but out of them only 60 variables are non empty.I removed those      columns which contains less than 500 non empty values. so only 60 variables and 19622 records I have taken for the prediction.
   I also removed column new window and X as new window have only one value overall and X does not have any statistical meaning it is        just a ID.
 
 2) Data Cleaning (remove Records): removed those records where new window =yes as in testing there is no record containing new             window=yes so removed those records.
 
 3) Created data partition of plm_training data into training and testing data by 60% and 40% of division.
 
 4) I removed classe column from testing data frame as we want to predict classe of the testing data.
 
 5) As this is the classification problem I have used algorithms such as Random Forest, Decision Tree and SVM classification and created model using these algorithms and predicted on testing data set (40% from training data) now again used this model to predict the problem set testing data of 20 records and created confusion matrix for each of these algorithms and taken maximum vote from the three models and generated final model by using stacking of algorithms 
 
these are the output of the prediction on 20 records using Decision Tree Random forest and SVM .

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

 
 
