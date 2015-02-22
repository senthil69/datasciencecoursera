#Cookbook 

## Introduction
This document describes the format of the data and steps performed to process the data 

Data Source : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

## Input Data 
  * activity_labels.txt - To map activity ID to a name 
  * features.txt  - To list the features that were measured
  * train/subject_train.txt 
  * train/X_train.txt
  * train/y_train.txt 
  * test/subject_test.txt
  * test/X_test.txt
  * test/y_test.txt

##Processing 
The following steps were taken to process the input data 

  * Load the features, activities in the table namely featureLabels and activityLabels
  * Load the training and test data (X,Y,subject)- The data is converted into numeric. In case of invalid values, NA is substituted 
  * Join the Y with activtyLabels,combine the colums (X,Y and subject) 
  * Filter the feature names with std and mean keyword (case insensitive) - Rest of the columns are dropped
  * Merge training and test set using rbind
  * Apply ddply on the data frame to group the values by person and activity 

##Output Data

The result file is result.csv. The fields follow the following naming convention 

  * mean - fields begin with this key word indicate mea value of the signal grouped by Person and activity
  * 'XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
  * t - used for time domain signals
  * f - used for frequency domain signals
  * mean/std appearing after the keyword denotes the mean and standard deviation 
  * person - Identifier between 1..30 provides identify of person
  * activity - possible values (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

