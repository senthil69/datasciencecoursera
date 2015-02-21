#Cookbook 

## Introduction
This document describes the format of the data and steps performed to process the data 

Data Source : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

##Data Semantics 

Download the URL and unzip the file. The files are stored under the directory "HAR Dataset".

"HAR DataSet/Readme.txt" - provides the high level summary of how the data acquistion is performed

##Processing

  * Load the features, activities in the table namely featureLabels and activityLabels
  * Load the training and test data (X,Y,subject)- The data is converted into numeric. In case of invalid values, NA is substituted 
  * Join the Y with activtyLabels,combine the colums (X,Y and subject) 
  * Filter the feature names with std and mean keyword (case insensitive) 
  * Merge training and test set using rbind
  * Apply ddply on the data frame to group the values by person and activity 


